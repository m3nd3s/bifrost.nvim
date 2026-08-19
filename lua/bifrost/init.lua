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
  local host, repo = remote:match("git@([^:]+):(.+)%.git$")
  if not host then
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

  local url = string.format("%s/blob/%s/%s", base, branch, rel_path)
  return line and (url .. "#L" .. line) or url
end

--- Função principal
---@param with_line boolean Se true, inclui a linha atual na URL
---@param open_browser boolean|nil Se true (padrão), abre o link no navegador
function M.launch(with_line, open_browser)
  if open_browser == nil then open_browser = true end

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

  local rel_path = file:sub(#git_root + 2):gsub("\\", "/")
  local line = with_line and vim.api.nvim_win_get_cursor(0)[1] or nil
  local target_url = build_url(host, repo, branch, rel_path, line)

  -- Sempre copia para a área de transferência (+)
  vim.fn.setreg("+", target_url)

  -- Abre no navegador apenas se solicitado
  if open_browser then
    if vim.ui.open then
      vim.ui.open(target_url)
    else
      local open_cmd = vim.fn.has("mac") == 1 and "open" or (vim.fn.has("win32") == 1 and "start" or "xdg-open")
      vim.fn.jobstart({ open_cmd, target_url }, { detach = true })
    end
    vim.notify("Bifrost: Link copiado e aberto!", vim.log.levels.INFO)
  else
    vim.notify("Bifrost: Link copiado para a área de transferência!", vim.log.levels.INFO)
  end
end

-- Aliases para facilitar chamadas na configuração
function M.open_file() M.launch(false, true) end
function M.open_line() M.launch(true, true) end
function M.copy_file() M.launch(false, false) end
function M.copy_line() M.launch(true, false) end

return M
