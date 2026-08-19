# 🌈 bifrost.nvim

> *"A ponte mágica que conecta seu código local diretamente aos reinos distantes do seu repositório Git."*

O **bifrost.nvim** é um plugin ultra-leve e 100% nativo em Lua para o NeoVim. Ele "teleporta" você do seu editor diretamente para o navegador, abrindo e copiando a URL exata do arquivo (ou da linha atual) no GitHub, GitLab ou Bitbucket, considerando a *branch* em que você está trabalhando no momento.

## ✨ Funcionalidades

- 🚀 **Sem dependências externas**: Feito inteiramente com as APIs nativas do NeoVim e comandos do Git.
- 📋 **Área de Transferência**: Copia automaticamente a URL gerada para o seu clipboard (`+`).
- 🌐 **Auto-Open**: Abre a URL automaticamente no navegador padrão do seu sistema operacional.
- 🎯 **Precisão**: Suporta abrir apenas o arquivo ou focar exatamente na linha em que o cursor está posicionado.
- 🏢 **Multi-provedores**: Suporte embutido para GitHub, GitLab e Bitbucket (facilmente extensível para instâncias self-hosted).

## 📦 Instalação

Você pode instalar o Bifrost usando o seu gerenciador de pacotes favorito.

### Usando [Packer](https://github.com/wbthomason/packer.nvim)

Adicione o trecho abaixo no seu arquivo de configuração do Packer:

```lua
use {
  'SEU_USUARIO/bifrost.nvim',
  config = function()
    local bifrost = require("bifrost")
    
    -- Configurando os atalhos (Keymaps)
    vim.keymap.set("n", "<leader>bf", function() bifrost.launch(false) end, { desc = "Bifrost: Abrir Arquivo no Git" })
    vim.keymap.set("n", "<leader>bl", function() bifrost.launch(true) end, { desc = "Bifrost: Abrir Linha no Git" })
  end
}
