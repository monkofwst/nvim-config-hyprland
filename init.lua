--------------My settings -------------
vim.opt.mouse = ""
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = {"utf-8", "cp1251", "latin1"}
vim.opt.relativenumber = false
vim.opt.number = true
--vim.opt.colorcolumn = "79"
vim.opt.clipboard = "unnamedplus"
vim.o.swapfile = false
-------- Keymaps --------
-- Map 'd' to delete using the black hole register
---vim.api.nvim_set_keymap('n', 'x', '"_d', { noremap = true, silent = true })
---vim.api.nvim_set_keymap('v', 'x', '"_d', { noremap = true, silent = true })
vim.keymap.set('n', '<C-`>', ':Neotree toggle<CR>', { noremap = true, silent = true })
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
                        "echasnovski/mini.nvim",
                        "nanotee/sqls.nvim",
                        {"nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = { 
                            "nvim-tree/nvim-web-devicons", 
                            "MunifTanjim/nui.nvim"}},
                        'nvim-lua/plenary.nvim',
                        {
                        "nvim-telescope/telescope.nvim",
                        tag = '0.1.6',
                        dependencies = { "nvim-lua/plenary.nvim" },
                        },
                        {
                        "nvim-telescope/telescope-fzf-native.nvim",
                        'preservim/nerdcommenter',
                        build = "make",
                        },
})
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
vim.g.gruvbox_material_transparent_background = 0  -- Set transparency level (0 to 2)

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
require'lspconfig'.clangd.setup{
    cmd = { "clangd", "--background-index" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = require('lspconfig.util').root_pattern("compile_commands.json", ".git"),
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
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
    -- "mini.ai",
    "mini.pairs",
    -- "mini.comment",
    "mini.surround",
    -- "mini.files",
    -- Add other mini modules as needed
  }

  for _, module in ipairs(mini_modules) do
    require(module).setup({})
  end
end

-- Call the loader function
require_mini()
-------- SQL lsp config --------
lspconfig.sqlls.setup {
    cmd = { "sql-language-server", "up", "--method", "stdio" },
    filetypes = { "sql", "mysql" },
    root_dir = function()
        return vim.loop.cwd() -- Set current working directory as root
    end,
}
------- Neo Tree config -------
require("neo-tree").setup {
    close_if_last_window = false,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = false,
    follow_current_file = true,
    view = {
        width = 30,
       side = "left",
        auto_resize = true,
    },
}
------- Telescope config -------
require('telescope').setup{
                defaults = {
                    path_display = {"truncate"},
                    mappings = {
                        i = {
                            ["<C-k>"] = require("telescope.actions").move_selection_previous,
                            ["<C-j>"] = require("telescope.actions").move_selection_next,
                            ["<C-q>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
                        },
                    },
                },
            }
require('telescope').load_extension('fzf')  -- Load fzf extension if installed

local keymap = vim.keymap
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {desc = "Fuzz find files in cwd"})
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", {desc = "Fuzzy find recent files"})
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", {desc = "Find string in cwd"})
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", {desc = "Find string under cursor in cwd"})
--------- mini.statusline config ---------
-- Define the function to get the file type icon
local function get_filetype_icon()
    local filename = vim.fn.expand('%:t')  -- Get current filename
    local file_ext = vim.fn.expand('%:e')  -- Get file extension
    local icon, _ = require'nvim-web-devicons'.get_icon(filename, file_ext, { default = true })  -- Get icon
    return icon or ''  -- Return icon or empty string if none found
end

require('mini.statusline').setup({
    content = {
        active = function()
            local filename = vim.fn.expand('%:t')  -- Get current file name
            local git_branch = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head or 'No Git'
            local line_col = string.format('Ln %d, Col %d', vim.fn.line('.'), vim.fn.col('.'))

            if git_branch == 'No Git' then
                return string.format('%s | %s | %s',
                    get_filetype_icon(),  -- Add file type icon
                    filename,
                    line_col
                )
            else
                return string.format('%s | %s | %s | %s',
                    get_filetype_icon(),  -- Add file type icon
                    filename,
                    git_branch,
                    line_col
                )
            end
        end,  -- Ensure this 'end' matches with 'active' function

        inactive = function()
            return 'Inactive Window'
        end,  -- Add 'end' for inactive function correctly
    },
    use_icons = true,  -- Enable icons by default
    set_vim_settings = true,  -- Set Vim's settings for statusline
})
