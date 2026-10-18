-- Neovim setup for st/i3: mouse friendly, with the system's charcoal/sage palette.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.updatetime = 250
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.hidden = true
vim.opt.confirm = true
vim.opt.undofile = true
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.showtabline = 2
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.mousemoveevent = true

vim.cmd("syntax enable")
vim.cmd.colorscheme("sage")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath,
    })
    if vim.v.shell_error ~= 0 then
        error("Could not install lazy.nvim:\n" .. out)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        {
            "nvim-tree/nvim-tree.lua",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            opts = {
                view = { width = 31, side = "left" },
                renderer = {
                    highlight_git = "name",
                    icons = {
                        show = { file = false, folder = false, folder_arrow = true, git = false },
                        glyphs = {
                            folder = { arrow_closed = ">", arrow_open = "v" },
                        },
                    },
                },
                filters = { dotfiles = false },
                git = { enable = true },
                on_attach = function(bufnr)
                    local api = require("nvim-tree.api")
                    api.config.mappings.default_on_attach(bufnr)
                    vim.keymap.set("n", "<LeftRelease>", api.node.open.edit,
                        { buffer = bufnr, silent = true, desc = "Open file or expand folder" })
                end,
            },
        },
        {
            "nvim-treesitter/nvim-treesitter",
            branch = "main",
            lazy = false,
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter").setup()
                vim.api.nvim_create_autocmd("FileType", {
                    pattern = { "bash", "sh", "c", "python", "rust", "markdown" },
                    callback = function(args)
                        pcall(vim.treesitter.start, args.buf)
                    end,
                })
            end,
        },
        { "neovim/nvim-lspconfig", lazy = false },
        { "hrsh7th/nvim-cmp", dependencies = {
            "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip",
        }, config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            cmp.setup({
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump()
                        else fallback() end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then luasnip.jump(-1)
                        else fallback() end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" }, { name = "luasnip" }, { name = "path" },
                }, { { name = "buffer" } }),
            })
        end },
        { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
        { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
        { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {
            sections = {
                lualine_x = {
                    { function() return " Save " end, on_click = function() vim.cmd("write") end },
                    { function() return " Find " end, on_click = function() require("telescope.builtin").find_files() end },
                },
            },
            options = {
                icons_enabled = false,
                theme = {
                    normal = { a = { fg = "#13171b", bg = "#7eb898", gui = "bold" }, b = { fg = "#cfd7de", bg = "#1a2026" }, c = { fg = "#6c7884", bg = "#13171b" } },
                    insert = { a = { fg = "#13171b", bg = "#8ed4aa", gui = "bold" } },
                    visual = { a = { fg = "#13171b", bg = "#5d9876", gui = "bold" } },
                    replace = { a = { fg = "#13171b", bg = "#e06c75", gui = "bold" } },
                    command = { a = { fg = "#13171b", bg = "#8ed4aa", gui = "bold" } },
                    inactive = { a = { fg = "#6c7884", bg = "#1a2026" }, b = { fg = "#6c7884", bg = "#1a2026" }, c = { fg = "#6c7884", bg = "#13171b" } },
                },
                globalstatus = true,
                section_separators = "",
                component_separators = "│",
            },
        } },
        { "akinsho/bufferline.nvim", version = "*", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {
            options = {
                show_buffer_icons = false,
                show_buffer_close_icons = false,
                show_close_icon = false,
                separator_style = "thin",
                diagnostics = "nvim_lsp",
                always_show_bufferline = true,
            },
        } },
        { "lewis6991/gitsigns.nvim", opts = {} },
        { "MeanderingProgrammer/render-markdown.nvim", dependencies = { "nvim-treesitter/nvim-treesitter" }, opts = {
            heading = { backgrounds = { "RenderMarkdownH1Bg", "RenderMarkdownH2Bg", "RenderMarkdownH3Bg" } },
            code = { sign = false },
        } },
        {
            "iamcco/markdown-preview.nvim",
            cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
            ft = { "markdown" },
            build = function() vim.fn["mkdp#util#install"]() end,
            init = function()
                vim.g.mkdp_filetypes = { "markdown" }
                vim.g.mkdp_theme = "dark"
                vim.g.mkdp_auto_close = 0
            end,
        },
    },
    install = { colorscheme = { "sage" } },
    checker = { enabled = false },
    change_detection = { notify = false },
})

vim.treesitter.language.register("bash", "sh")

-- Use the system-installed language servers.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
for _, server in ipairs({ "rust_analyzer", "pylsp", "bashls", "clangd" }) do
    vim.lsp.config(server, { capabilities = capabilities })
    vim.lsp.enable(server)
end

vim.diagnostic.config({
    virtual_text = { spacing = 2, prefix = "●" },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded", source = true },
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local opts = { buffer = event.buf, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show documentation" }))
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostic" }))
    end,
})

local map = vim.keymap.set
map("n", "<C-b>", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })
map("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find file" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Search in project" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Open buffer" })
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "File explorer" })
map("n", "<leader>g", "<cmd>lua require('telescope.builtin').git_status()<cr>", { desc = "Git status" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>confirm quit<cr>", { desc = "Close editor" })
map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown preview" })
map("n", "<C-Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next tab" })
map("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous tab" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
        vim.opt_local.conceallevel = 2
    end,
})
