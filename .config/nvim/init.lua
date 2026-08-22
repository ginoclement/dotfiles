-- ~/.config/nvim/init.lua — Gino Clement
-- Modernized from the old .vimrc; no plugins required.

local opt = vim.opt

-- UI
opt.number = true            -- show line numbers
opt.showmatch = true         -- highlight matching brackets
opt.wildmenu = true          -- command-line completion menu
opt.lazyredraw = true        -- only redraw when needed
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 4            -- keep context above/below the cursor
opt.cursorline = true

-- Tabs (4-wide, as before)
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

-- Searching
opt.incsearch = true         -- highlight while typing
opt.hlsearch = true
opt.ignorecase = true        -- case-insensitive...
opt.smartcase = true         -- ...unless the search has capitals

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"  -- use system clipboard
opt.undofile = true            -- persistent undo across restarts
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 300

-- Colorscheme: habamax ships with neovim and is close in spirit to badwolf
pcall(vim.cmd.colorscheme, "habamax")

-- Esc clears search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })

-- Sensible defaults for the files you touch most
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "yaml", "yml", "json", "sh", "zsh", "lua" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})
