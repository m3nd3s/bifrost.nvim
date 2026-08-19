# 🌈 bifrost.nvim

> *"A ponte mágica que conecta seu código local diretamente aos reinos distantes do seu repositório Git."*

O **bifrost.nvim** é um plugin ultra-leve e 100% nativo em Lua para o NeoVim. Ele "teleporta" você do seu editor diretamente para a Web, permitindo abrir no navegador ou **apenas copiar** a URL exata do arquivo ou da linha atual no GitHub, GitLab ou Bitbucket, considerando a *branch* ativa.

## ✨ Funcionalidades

* 🚀 **Sem dependências externas**: Feito inteiramente com APIs nativas do NeoVim e comandos do Git.
* 🌐 **Abrir ou Apenas Copiar**: Escolha entre abrir diretamente no navegador ou apenas salvar a URL no clipboard (`+`).
* 🎯 **Precisão de Linha**: Opções para focar no arquivo inteiro ou exatamente na linha em que o cursor está posicionado.
* 📋 **Auto-Clipboard**: Todas as ações de abertura também copiam o link automaticamente para a área de transferência.
* 🏢 **Multi-provedores**: Suporte a GitHub, GitLab e Bitbucket out-of-the-box.

---

## 📦 Instalação

### Usando [Packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'm3nd3s/bifrost.nvim',
  config = function()
    local bifrost = require("bifrost")

    -- Mapeamentos sugeridos
    vim.keymap.set("n", "<leader>bo", bifrost.open_file, { desc = "Bifrost: Abrir arquivo no Git" })
    vim.keymap.set("n", "<leader>bl", bifrost.open_line, { desc = "Bifrost: Abrir linha no Git" })
    vim.keymap.set("n", "<leader>bc", bifrost.copy_file, { desc = "Bifrost: Copiar link do arquivo" })
    vim.keymap.set("n", "<leader>by", bifrost.copy_line, { desc = "Bifrost: Copiar link da linha" })
  end
}
```

### Usando [Lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "m3nd3s/bifrost.nvim",
  keys = {
    { "<leader>bo", function() require("bifrost").open_file() end, desc = "Bifrost: Abrir arquivo no Git" },
    { "<leader>bl", function() require("bifrost").open_line() end, desc = "Bifrost: Abrir linha no Git" },
    { "<leader>bc", function() require("bifrost").copy_file() end, desc = "Bifrost: Copiar link do arquivo" },
    { "<leader>by", function() require("bifrost").copy_line() end, desc = "Bifrost: Copiar link da linha" },
  },
}
```

> **Nota:** Se o repositório for privado, utilize a URL SSH `'git@github.com:m3nd3s/bifrost.nvim.git'`.

---

## 🎮 Funções e Uso

| Função Lua | Descrição |
| :--- | :--- |
| `bifrost.open_file()` | Copia a URL do arquivo e abre no navegador |
| `bifrost.open_line()` | Copia a URL da linha atual e abre no navegador |
| `bifrost.copy_file()` | **Apenas copia** a URL do arquivo para o clipboard |
| `bifrost.copy_line()` | **Apenas copia** a URL da linha atual para o clipboard |

### Comandos de Usuário (Opcional)

```lua
local bifrost = require("bifrost")

vim.api.nvim_create_user_command
