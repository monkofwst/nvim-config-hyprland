--------------My settings -------------
vim.opt.mouse = "a"
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = {"utf-8", "cp1251", "latin1"}
vim.opt.relativenumber = false
vim.opt.number = true
--vim.opt.colorcolumn = "79"
vim.opt.clipboard = "unnamedplus"
-------------- Default settings ------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
   "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-------------- Installing packages -------------
require("lazy").setup({"neovim/nvim-lspconfig",
                        "hrsh7th/nvim-cmp",
                        "hrsh7th/cmp-nvim-lsp",
                        "hrsh7th/cmp-buffer",
                        "hrsh7th/cmp-path",
                        "rafamadriz/friendly-snippets",
                        "saadparwaiz1/cmp_luasnip",
                        "L3MON4D3/LuaSnip",
                        "p00f/clangd_extensions.nvim",
                        "sainnhe/gruvbox-material",
                        "echasnovski/mini.nvim"})
require("vim-options")
local vim = vim
--------- Themes config --------
--Set background to dark or light
vim.o.background = "dark"  -- or "light"

-- Load the Gruvbox Material colorscheme
vim.cmd('colorscheme gruvbox-material')

-- Optional: Configure additional settings
vim.g.gruvbox_material_enable_italic_comment = 1  -- Enable italic comments

vim.g.gruvbox_material_palette = "material"  -- Choose a palette: 'material', 'mix', or 'original'
vim.g.gruvbox_material_transparent_background = 2  -- Set transparency level (0 to 2)

vim.cmd('syntax on')           -- Enable syntax highlighting
vim.cmd('filetype plugin on')  -- Enable filetype detection and plugins

--------- LSP config --------
local lspconfig = require('lspconfig')

lspconfig.pyright.setup{
    on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- Mappings
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap=true, silent=true })
        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap=true, silent=true })
        
        -- Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    end,
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    settings = {
        python = {
            pythonPath = "/usr/bin/python3"  -- Adjust this path as needed
        }
    }
}

lspconfig.clangd.setup{
    on_attach = function(client, bufnr)
        -- Set up inlay hints
        require("clangd_extensions.inlay_hints").setup_autocmd()
        require("clangd_extensions.inlay_hints").set_inlay_hints()

        -- Optional: Key mappings for toggling inlay hints
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lh', '<cmd>ClangdToggleInlayHints<CR>', { noremap = true, silent = true })
    end,
    capabilities = {
        -- Add any specific capabilities here if needed
    },
}

-------------- nvim-cmp --------------
local cmp = require'cmp'

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For luasnip users.
        end,
    },
    mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'luasnip' },
    },
})

-- Set completeopt to have a better completion experience
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
------------ mini config -----------
local function require_mini()
  local mini_modules = {
    "mini.ai",
    "mini.pairs",
    "mini.comment",
    "mini.surround",
    "mini.files",
    "mini.statusline",
    -- Add other mini modules as needed
  }

  for _, module in ipairs(mini_modules) do
    require(module).setup({})
  end
end

-- Call the loader function
require_mini()

