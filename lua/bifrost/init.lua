local M = {}

local function git_exec(cmd)
  local handle = io.popen(cmd)
  if not handle then return nil end
  local result = handle:read("*a")
  handle:close()
  return vim.trim(result)
end

local function parse_remote(remote)
  if not remote or remote == "" then return nil, nil end
  -- Trata formato SSH (git@github.com:user/repo.git)
  local host, repo = remote:match("git@([^:]+):(.+)%.git$")
  if not host then
    -- Trata formato HTTPS (https://github.com/user/repo.git)
    host, repo = remote:match("https?://([^/]+)/(.+)%.git$")
  end
  return host, repo
end

local function build_url(host, repo, branch, rel_path, line)
  local base = string.format("https://%s/%s", host, repo)
  
  if host:find("github.com") then
    local url = string.format("%s/blob/%s/%s", base, branch, rel_path)
    return line and (url .. "#L" .. line) or url
  elseif host:find("gitlab.com") then
    local url = string.format("%s/-/blob/%s/%s", base, branch, rel_path)
    return line and (url .. "#L" .. line) or url
  elseif host:find("bitbucket.org") then
    local url = string.format("%s/src/%s/%s", base, branch, rel_path)
    return line and (url .. "#lines-" .. line) or url
  end

  -- Fallback genérico
  local url = string.format("%s/blob/%s/%s", base, branch, rel_path)
  return line and (url .. "#L" .. line) or url
end

function M.launch(with_line)
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Bifrost: Nenhum arquivo válido aberto.", vim.log.levels.WARN)
    return
  end

  local git_root = git_exec("git rev-parse --show-toplevel")
  if not git_root or git_root:find("fatal") then
    vim.notify("Bifrost: Fora de um repositório Git.", vim.log.levels.WARN)
    return
  end

  local branch = git_exec("git rev-parse --abbrev-ref HEAD")
  local remote = git_exec("git remote get-url origin")
  local host, repo = parse_remote(remote)

  if not host or not repo then
    vim.notify("Bifrost: Não foi possível identificar o remote 'origin'.", vim.log.levels.ERROR)
    return
  end

  -- Calcula o caminho relativo do arquivo em relação à raiz do git
  local rel_path = file:sub(#git_root + 2):gsub("\\", "/")
  local line = with_line and vim.api.nvim_win_get_cursor(0)[1] or nil
  local target_url = build_url(host, repo, branch, rel_path, line)

  -- Copia para a área de transferência do sistema (registro +)
  vim.fn.setreg("+", target_url)

  -- Abre o navegador usando a API nativa do NeoVim
  if vim.ui.open then
    vim.ui.open(target_url)
  else
    -- Fallback para versões mais antigas
    local open_cmd = vim.fn.has("mac") == 1 and "open" or (vim.fn.has("win32") == 1 and "start" or "xdg-open")
    vim.fn.jobstart({ open_cmd, target_url }, { detach = true })
  end

  vim.notify("Bifrost: Link copiado e aberto!", vim.log.levels.INFO)
end

return M
