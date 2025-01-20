


### Install Neovim (Python Support)

To configure Neovim as a lightweight Python IDE, we'll include a Linter, LSP, and Formatter for Python:
- Linter: Use [flake8](https://flake8.pycqa.org/en/latest/) for linting Python code.
- Formatter: Use [black](https://black.readthedocs.io/en/stable/index.html) for consistent code formatting.
- LSP: Use pyright for language server support.

---

Install black for code formatting

```
{
pip3 install --user  black
export PATH="$HOME/.local/bin:$PATH"
echo -e '\nexport PATH="$HOME/.local/bin:$PATH"' >>  ~/.bashrc 
}
```

Install flake8 for 

```
pip3 install --user flake8 
```



Install black for code formatting

```
{
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
node --version
npm --version
}
```




Configure the python lsp for lazyvim

```
cat << EOF | tee ~/.config/nvim/lua/plugins/python.lua
return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").pyright.setup({})
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.flake8,
          null_ls.builtins.formatting.black,
        },
      })
    end,
  },
}
EOF
```

