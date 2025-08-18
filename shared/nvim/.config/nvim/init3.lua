-- Plugins and ordering

-- folke/lazy.nvim - Plugin Manager  `:Lazy update`
--     (disabled) christoomey/vim-tmux-navigator - Seamless tmux-pane/nvim-split navigation.
--     lewis6991/gitsigns.nvim - Git files, line, and hunk annotations
--     folke/which-key.nvim - Key finder helper
--     ibhagwan/fzf-lua - Fuzzy finder (performance biased)
--     (disabled) nvim-telescope/telescope.nvim - Fuzzy Finder (feature biased)
--     folke/lazydev.nvim - Lua LS for Neovim config
--     neovim/nvim-lspconfig - LSP Config
--         mason-org/mason.nvim - LSP Server Manager
--         mason-org/mason-lspconfig.nvim
--         WhoIsSethDaniel/mason-tool-installer.nvim
--         j-hui/fidget.nvim - LSP status line
--         saghen/blink.cmp
--     stevearc/conform.nvim - source formatter
--     saghen/blink.cmp - completion plugin
--     (disabled) catppuccin/nvim - popular theme
--     (disabled) rebelot/kanagawa.nvim - nice theme
--     folke/todo-comments.nvim - Better comment markers
--     echasnovski/mini.nvim - Plugin bundle with surround, themes
--         require("mini.ai").setup({ n_lines = 500 })
--         require("mini.surround").setup()
--         local statusline = require("mini.statusline")
--
--     nvim-treesitter/nvim-treesitter - Syntax highlighting
--     (disabled) famiu/bufdelete.nvim - prevent buffer deletes from breaking window layout
--     akinsho/bufferline.nvim - Buffer-tab line
--     nvim-neo-tree/neo-tree.nvim - File Explorer side bar

-- --------------------------------------------------------
-- Plugin Free Configuration
-- --------------------------------------------------------
-- theme & transparency
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
vim.g.have_nerd_font = true

-- Basic settings
vim.opt.number = true -- Line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.wrap = false -- Don't wrap lines
vim.opt.scrolloff = 10 -- Keep 10 lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor

-- While I intend to use a plugin for theme, we want to know there is a nice fallback.
if vim.loop.fs_stat(vim.fn.expand("~/.light_theme")) then
	vim.opt.background = "light"
	vim.cmd.colorscheme("morning")
	--vim.cmd.colorscheme("kanagawa-lotus")
	vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#dddddd", ctermbg = 0 })
	vim.api.nvim_set_hl(0, "CursorLine", { bg = "#dddddd", underline = false })
	vim.api.nvim_set_hl(0, "Whitespace", { fg = "#bcbcbc", ctermfg = 8 })
else
	vim.opt.background = "dark"
	vim.cmd.colorscheme("desert")
	--vim.cmd.colorscheme("kanagawa-dragon")
	vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#0c0c0c", ctermbg = 0 })
	vim.api.nvim_set_hl(0, "CursorLine", { bg = "#0c0c0c", underline = false })
	vim.api.nvim_set_hl(0, "Whitespace", { fg = "#2c2c2c", ctermfg = 8 })
end

-- Remove italics (after colorscheme)
local groups = { "Comment", "Function", "Type", "Keyword", "Statement", "Identifier" }
for _, group in ipairs(groups) do
	local group_hl = vim.api.nvim_get_hl(0, { name = group })
	group_hl.italic = false
	vim.api.nvim_set_hl(0, group, group_hl)
end

-- Indentation
vim.opt.tabstop = 2 -- Tab width
vim.opt.shiftwidth = 2 -- Indent width
vim.opt.softtabstop = 2 -- Soft tab stop
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smart auto-indenting
vim.opt.autoindent = true -- Copy indent from current line

-- Search settings
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive if uppercase in search
vim.opt.hlsearch = false -- Don't highlight search results
vim.opt.incsearch = true -- Show matches as you type

-- Visual settings
vim.opt.termguicolors = true -- Enable 24-bit colors
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.colorcolumn = "100" -- Show column at 100 characters
vim.opt.showmatch = true -- Highlight matching brackets
vim.opt.matchtime = 2 -- How long to show matching bracket
vim.opt.cmdheight = 1 -- Command line height
vim.opt.completeopt = "menuone,noinsert,noselect" -- Completion options
vim.opt.showmode = false -- Don't show mode in command line
vim.opt.pumheight = 10 -- Popup menu height
vim.opt.pumblend = 10 -- Popup menu transparency
vim.opt.winblend = 0 -- Floating window transparency
vim.opt.conceallevel = 0 -- Don't hide markup
vim.opt.concealcursor = "" -- Don't hide cursor line markup
vim.opt.lazyredraw = true -- Don't redraw during macros
vim.opt.synmaxcol = 300 -- Syntax highlighting limit

-- File handling
vim.opt.backup = false -- Don't create backup files
vim.opt.writebackup = false -- Don't create backup before writing
vim.opt.swapfile = false -- Don't create swap files
vim.opt.undofile = true -- Persistent undo
vim.opt.undodir = vim.fn.expand("~/.vim/undodir") -- Undo directory
vim.opt.updatetime = 300 -- Faster completion
vim.opt.timeoutlen = 500 -- Key timeout duration
vim.opt.ttimeoutlen = 0 -- Key code timeout
vim.opt.autoread = true -- Auto reload files changed outside vim
vim.opt.autowrite = false -- Don't auto save

-- Behavior settings
vim.opt.hidden = true -- Allow hidden buffers
vim.opt.errorbells = false -- No error bells
vim.opt.backspace = "indent,eol,start" -- Better backspace behavior
vim.opt.autochdir = false -- Don't auto change directory
vim.opt.iskeyword:append("-") -- Treat dash as part of word
vim.opt.path:append("**") -- include subdirectories in search
vim.opt.selection = "exclusive" -- Selection behavior
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard
vim.opt.modifiable = true -- Allow buffer modifications
vim.opt.encoding = "UTF-8" -- Set encoding

-- Cursor settings
vim.opt.guicursor =
	"n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Folding settings
vim.opt.foldmethod = "expr" -- Use expression for folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use treesitter for folding
vim.opt.foldlevel = 99 -- Start with all folds open

-- Split behavior
vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.splitright = true -- Vertical splits go right

-- Key mappings
vim.g.mapleader = " " -- Set leader key to space
vim.g.maplocalleader = " " -- Set local leader key (NEW)

---- early in your config, before lazy.setup()
--CUSTOM_WK_KEYS = {
--  ["<leader>a"] = { "<cmd>Alpha<cr>", "Alpha dashboard" },
--}
--
---- in lazy setup
--{
--  "folke/which-key.nvim",
--  event = "VeryLazy",
--  config = function()
--    require("which-key").setup({})
--    require("which-key").register(MY_WK_KEYS)
--  end,
--}

-- Normal mode mappings
vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Y to EOL
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
--vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
--vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- Better paste behavior
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Splitting & Resizing
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Quick file navigation
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>ff", ":find ", { desc = "Find file" })

-- Better J behavior
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Quick config editing
vim.keymap.set("n", "<leader>rc", ":e $MYVIMRC<CR>", { desc = "Edit config" })
vim.keymap.set("n", "<leader>rl", ":so $MYVIMRC<CR>", { desc = "Reload config" })

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Keybinds to make split navigation easier.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Keymaps for the fzf lua plugin
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua grep_project<CR>")
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua grep_project<CR>")
vim.keymap.set("n", "<leader>fx", "<cmd>FzfLua diagnostics_document<CR>")
vim.keymap.set("n", "<leader>fX", "<cmd>FzfLua diagnostics_workspace<CR>")
vim.keymap.set("n", "<leader>fc", "<cmd>FzfLua git_bcommits<CR>")
vim.keymap.set("n", "<leader>fl", "<cmd>FzfLua lsp_references<CR>")

-- Neotree plugin keymaps
vim.keymap.set("n", "\\", ":Neotree reveal<CR>", { desc = "Neotree reveal", silent = true })

-- Keymaps for lsp are in lsp setup (defined below)
--vim.keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "[R]e[n]ame"})
--vim.keymap.set("n", "gra", vim.lsp.buf.code_action, { desc = "[G]oto Code [A]ction" })
--vim.keymap.set("x", "gra", vim.lsp.buf.code_action, { desc = "[G]oto Code [A]ction" })
--vim.keymap.set("n", "grD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })
--vim.keymap.set("n", "grr", function() require("fzf-lua").lsp_references() end, { desc = "[G]oto [R]eferences" })
--vim.keymap.set("n", "gri", function() require("fzf-lua").lsp_implementations() end, { desc = "[G]oto [I]mplementation"})
--vim.keymap.set("n", "grd", function() require("fzf-lua").lsp_definitions() end, { desc = "[G]oto [D]efinition" })
--vim.keymap.set("n", "gO", function() require("fzf-lua").lsp_document_symbols() end, { desc = "Open Document Symbols" })
--vim.keymap.set("n", "gW", function() require("fzf-lua").lsp_workspace_symbols() end, { desc = "Open Workspace Symbols" })
--vim.keymap.set("n", "grt", function() require("fzf-lua").lsp_type_definitions() end, { desc = "[G]oto [T]ype Definition" })

-- Tmux-pane/nvim-split navigation (defined below)
--vim.keymap.set("n", "<C-h>", function() tmux_or_nvim_nav("h", "L") end, { desc = "Move left" })
--vim.keymap.set("n", "<C-j>", function() tmux_or_nvim_nav("j", "D") end, { desc = "Move down" })
--vim.keymap.set("n", "<C-k>", function() tmux_or_nvim_nav("k", "U") end, { desc = "Move up" })
--vim.keymap.set("n", "<C-l>", function() tmux_or_nvim_nav("l", "R") end, { desc = "Move right" })

-- Putting this after the theme plugin.
vim.opt.cursorcolumn = true
vim.opt.cursorline = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.termguicolors = true

vim.cmd("filetype indent off")
vim.opt.smartindent = false
vim.opt.cindent = false
vim.opt.indentexpr = ""

-- what is this
vim.opt.fillchars = {
	vert = "│",
	horiz = "─",
	eob = " ",
}

-- Enable break indent
vim.o.breakindent = true

-- Sets how neovim will display certain whitespace characters in the editor.
-- vim.o.list = true
-- vim.opt.listchars = { tab = "→ ", trail = "·", space = " ", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

--vim.api.nvim_create_autocmd("VimEnter", {
--	callback = function()
--		require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
--	end,
--})

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
local function paste()
	return {
		vim.fn.split(vim.fn.getreg(""), "\n"),
		vim.fn.getregtype(""),
	}
end
--vim.schedule(function()
vim.o.clipboard = "unnamedplus"

vim.g.clipboard = {
	name = "OSC 52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = paste,
		["*"] = paste,
	},
}
--end)

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Replicates what I need from bufdelete.nvim
function DeleteBufferKeepWindow(bufnr)
	local current_buf = bufnr or vim.api.nvim_get_current_buf()
	local alt_buf = vim.fn.bufnr("#") -- Alternate buffer (previous one)

	-- Pick a fallback buffer to show in windows (not current one)
	local fallback = (alt_buf ~= current_buf and vim.fn.buflisted(alt_buf) == 1) and alt_buf or nil
	if not fallback then
		-- If no alternate buffer, find any listed buffer
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) and vim.fn.buflisted(buf) == 1 and buf ~= current_buf then
				fallback = buf
				break
			end
		end
	end

	-- Replace current buffer in all windows with fallback
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == current_buf then
			if fallback then
				vim.api.nvim_win_set_buf(win, fallback)
			end
		end
	end

	-- Now safely delete the buffer
	vim.api.nvim_buf_delete(current_buf, { force = true })
end
vim.keymap.set("n", "<leader>bx", function()
	DeleteBufferKeepWindow()
end, { desc = "Delete buffer (keep window)" })

-- Replicates what I need from vim-tmux-navigation
local function tmux_or_nvim_nav(key, flag)
	local cur_win = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. key)
	local new_win = vim.api.nvim_get_current_win()

	if cur_win == new_win and os.getenv("TMUX") then
		os.execute("tmux select-pane -" .. flag)
	end
end

-- Keybindings for Tmux-aware navigation
vim.keymap.set("n", "<C-h>", function()
	tmux_or_nvim_nav("h", "L")
end, { desc = "Move left" })
vim.keymap.set("n", "<C-j>", function()
	tmux_or_nvim_nav("j", "D")
end, { desc = "Move down" })
vim.keymap.set("n", "<C-k>", function()
	tmux_or_nvim_nav("k", "U")
end, { desc = "Move up" })
vim.keymap.set("n", "<C-l>", function()
	tmux_or_nvim_nav("l", "R")
end, { desc = "Move right" })

---------------------------- Plugin Stuff Starts Here ---------------------

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
	-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
	--"NMAC427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically

	-- See `:help gitsigns` to understand what the configuration keys do
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			-- delay between pressing a key and opening which-key (milliseconds)
			-- this setting is independent of vim.o.timeoutlen
			delay = 0,
			icons = {
				-- set icon mappings to true if you have a Nerd Font
				mappings = vim.g.have_nerd_font,
				-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
				-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			-- Document existing key chains
			--spec = {
			--	{ "<leader>s", group = "[S]earch" },
			--	{ "<leader>t", group = "[T]oggle" },
			--	--{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			--	{ "<leader>bd", "<cmd>Bd<CR>", desc = "Close Buffer" },
			--	{ "<leader>bn", "<cmd>bn<CR>", desc = "New Buffer" },
			--	{ "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Git Hunk Preview" },
			--	{ "<leader>hb", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Git Blame" },
			--	--{ "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Pane Left" },
			--	--{ "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Pane Right" },
			--	--{ "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Pane Down" },
			--	--{ "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Pane Up" },
			--	{ "<C-s>", "<cmd>write<CR>", desc = "Save File" },
			--	{ "<leader>hh", "<cmd>sp<CR>", desc = "Horiz Split" },
			--	{ "<leader>vv", "<cmd>vsp<CR>", desc = "Vertical Split" },
			--	{ "<C-d>", "<C-d>zz", mode = { "n" } },
			--	{ "<C-u>", "<C-u>zz", desc = "1/2 Page Down Centered", mode = { "n" } },
			--	{ "n", "nzzzv", desc = "Search Fwd Centered", mode = { "n" } },
			--	{ "N", "Nzzzv", desc = "Search Bkw Centered", mode = { "n" } },
			--},
		},
	},

	{ -- ibhagwan/fzf-lua
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "echasnovski/mini.icons" },
		opts = {},
		config = function()
			require("fzf-lua").setup()
		end,
	},

	-- LSP Plugins
	{ -- folke/lazydev.nvim
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{ -- neovim/nvim-lspconfig
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by blink.cmp
			"saghen/blink.cmp",
		},
		config = function()
			--  This function gets run when an LSP attaches to a particular buffer.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Rename the variable under your cursor.
					vim.keymap.set("n", "grn", vim.lsp.buf.rename, { buffer = event.buf, desc = "[R]e[n]ame" })
					-- Execute a code action, usually your cursor needs to be on top of an error
					vim.keymap.set(
						"n",
						"gra",
						vim.lsp.buf.code_action,
						{ buffer = event.buf, desc = "[G]oto Code [A]ction" }
					)
					vim.keymap.set(
						"x",
						"gra",
						vim.lsp.buf.code_action,
						{ buffer = event.buf, desc = "[G]oto Code [A]ction" }
					)
					-- WARN: This is not Goto Definition, this is Goto Declaration.
					vim.keymap.set(
						"n",
						"grD",
						vim.lsp.buf.declaration,
						{ buffer = event.buf, desc = "[G]oto [D]eclaration" }
					)
					-- Find references for the word under your cursor.
					vim.keymap.set("n", "grr", function()
						require("fzf-lua").lsp_references()
					end, { buffer = event.buf, desc = "[G]oto [R]eferences" })
					-- Jump to the implementation of the word under your cursor.
					vim.keymap.set("n", "gri", function()
						require("fzf-lua").lsp_implementations()
					end, { buffer = event.buf, desc = "[G]oto [I]mplementation" })
					-- Jump to the definition of the word under your cursor.
					vim.keymap.set("n", "grd", function()
						require("fzf-lua").lsp_definitions()
					end, { buffer = event.buf, desc = "[G]oto [D]efinition" })
					-- Fuzzy find all the symbols in your current document.
					vim.keymap.set("n", "gO", function()
						require("fzf-lua").lsp_document_symbols()
					end, { buffer = event.buf, desc = "Open Document Symbols" })
					-- Fuzzy find all the symbols in your current workspace.
					vim.keymap.set("n", "gW", function()
						require("fzf-lua").lsp_workspace_symbols()
					end, { buffer = event.buf, desc = "Open Workspace Symbols" })
					-- Jump to the type of the word under your cursor.
					vim.keymap.set("n", "grt", function()
						require("fzf-lua").lsp_type_definitions()
					end, { buffer = event.buf, desc = "[G]oto [T]ype Definition" })

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`ts_ls`) will work just fine
				-- ts_ls = {},
				--

				--lua_ls = {
				--	-- cmd = { ... },
				--	-- filetypes = { ... },
				--	-- capabilities = {},
				--	settings = {
				--		Lua = {
				--			completion = {
				--				callSnippet = "Replace",
				--			},
				--			-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
				--			-- diagnostics = { disable = { 'missing-fields' } },
				--		},
				--	},
				--},
			}

			-- Ensure the servers and tools above are installed: `:Mason`
			-- You can press `g?` for help in this menu.

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, { "stylua" })
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	{ -- Autoformat stevearc/conform.nvim
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = false, cpp = false }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				cpp = { "clang_format" },
				c = { "clang_format" },
				html = { "djlint" },
				htmldjango = { "djlint" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
			},
			formatters = {
				djlint = {
					command = "djlint",
					args = { "--reformat", "-" },
					stdin = true,
					prepend_args = function()
						return {
							"--indent",
							"2",
							"--max-line-length",
							"120",
							"--max-blank-lines",
							"2",
						}
					end,
				},
			},
		},
	},

	{ -- Autocompletion saghen/blink.cmp
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					-- {
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
				opts = {},
			},
			"folke/lazydev.nvim",
		},
		opts = {
			keymap = {
				-- 'default' (recommended) for mappings similar to built-in completions
				--   <c-y> to accept ([y]es) the completion.
				--    This will auto-import if your LSP supports it.
				--    This will expand snippets if the LSP sent a snippet.
				-- 'super-tab' for tab to accept
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- For an understanding of why the 'default' preset is recommended,
				-- you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				--
				-- All presets have the following mappings:
				-- <tab>/<s-tab>: move to right/left of your snippet expansion
				-- <c-space>: Open menu or open docs if already open
				-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
				-- <c-e>: Hide menu
				-- <c-k>: Toggle signature help
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				preset = "default",

				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},

			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			snippets = { preset = "luasnip" },

			-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
			-- which automatically downloads a prebuilt binary when enabled.
			--
			-- By default, we use the Lua implementation instead, but you may enable
			-- the rust implementation via `'prefer_rust_with_warning'`
			--
			-- See :h blink-cmp-config-fuzzy for more information
			fuzzy = { implementation = "lua" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},

	{ -- rebelot/kanagawa.nvim
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				transparent = true,
			})
			local uv = vim.loop -- Neovim's libuv wrapper
			local light_theme_path = vim.fn.expand("~/.light_theme")
			local file_exists = uv.fs_stat(light_theme_path) ~= nil
			if file_exists then
				vim.o.background = "light"
				vim.cmd.colorscheme("kanagawa-lotus")
				vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#dddddd", ctermbg = 0 })
				vim.api.nvim_set_hl(0, "CursorLine", { bg = "#dddddd", underline = false })
				vim.api.nvim_set_hl(0, "Whitespace", { fg = "#bcbcbc", ctermfg = 8 })
			else
				vim.o.background = "dark"
				vim.cmd.colorscheme("kanagawa-dragon")
				vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#0c0c0c", ctermbg = 0 })
				vim.api.nvim_set_hl(0, "CursorLine", { bg = "#0c0c0c", underline = false })
				vim.api.nvim_set_hl(0, "Whitespace", { fg = "#2c2c2c", ctermfg = 8 })
			end
		end,
	},

	-- Highlight todo, notes, etc in comments
	{ -- folke/todo-comments.nvim
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{ -- Collection of various small independent plugins/modules (mini collection)
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			local statusline = require("mini.statusline")
			-- set use_icons to true if you have a Nerd Font
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			-- You can configure sections in the statusline by overriding their
			-- default behavior. For example, here we set the section for
			-- cursor location to LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			--  Check out: https://github.com/echasnovski/mini.nvim
		end,
	},

	{ -- Highlight, edit, and navigate code nvim-treesitter
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = {
				"ada",
				"agda",
				"angular",
				"apex",
				"arduino",
				"asm",
				"astro",
				"authzed",
				"awk",
				"bash",
				"bass",
				"beancount",
				"bibtex",
				"bicep",
				"bitbake",
				"blade",
				"blueprint",
				"bp",
				"brightscript",
				"c",
				"c_sharp",
				"caddy",
				"cairo",
				"capnp",
				"chatito",
				"circom",
				"clojure",
				"cmake",
				"comment",
				"commonlisp",
				"cooklang",
				"corn",
				"cpon",
				"cpp",
				"css",
				"csv",
				"cuda",
				"cue",
				"cylc",
				"d",
				"dart",
				"desktop",
				"devicetree",
				"dhall",
				"diff",
				"disassembly",
				"djot",
				"dockerfile",
				"dot",
				"doxygen",
				"dtd",
				"earthfile",
				"ebnf",
				"editorconfig",
				"eds",
				"eex",
				"elixir",
				"elm",
				"elsa",
				"elvish",
				"embedded_template",
				"enforce",
				"erlang",
				"facility",
				"faust",
				"fennel",
				"fidl",
				"firrtl",
				"fish",
				"foam",
				"forth",
				"fortran",
				"fsh",
				"fsharp",
				"func",
				"fusion",
				"gap",
				"gaptst",
				"gdscript",
				"gdshader",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"git_config",
				"gitignore",
				"gleam",
				"glimmer",
				"glimmer_javascript",
				"glimmer_typescript",
				"glsl",
				"gn",
				"gnuplot",
				"go",
				"goctl",
				"godot_resource",
				"gomod",
				"gosum",
				"gowork",
				"gotmpl",
				"gpg",
				"gren",
				"groovy",
				"graphql",
				"gstlaunch",
				"hack",
				"hare",
				"haskell",
				"haskell_persistent",
				"hcl",
				"heex",
				"helm",
				"hjson",
				"hlsl",
				"hocon",
				"hoon",
				"html",
				"htmldjango",
				"http",
				"hurl",
				"hyprlang",
				"idl",
				"idris",
				"ini",
				"inko",
				--error "ipkg",
				"ispc",
				"janet_simple",
				"java",
				"javadoc",
				"javascript",
				"jinja",
				"jinja_inline",
				"jq",
				"jsdoc",
				"json",
				"json5",
				"jsonc",
				"jsonnet",
				"julia",
				"just",
				"kcl",
				"kconfig",
				"kdl",
				"kotlin",
				"koto",
				"kusto",
				"lalrpop",
				--error "latex",
				"ledger",
				"leo",
				"llvm",
				"linkerscript",
				"liquid",
				"liquidsoap",
				"lua",
				"luadoc",
				"luap",
				"luau",
				"hlsplaylist",
				"m68k",
				"make",
				"markdown",
				"markdown_inline",
				"matlab",
				"menhir",
				"mermaid",
				"meson",
				--error "mlir",
				"muttrc",
				"nasm",
				"nginx",
				"nickel",
				"nim",
				"nim_format_string",
				"ninja",
				"nix",
				"norg",
				"nqc",
				"nu",
				"objc",
				"objdump",
				"ocaml",
				"ocaml_interface",
				--error "ocamllex",
				"odin",
				"pascal",
				"passwd",
				"pem",
				"perl",
				"php",
				"php_only",
				"phpdoc",
				"pioasm",
				"po",
				"pod",
				"poe_filter",
				"pony",
				"powershell",
				"printf",
				"prisma",
				"problog",
				"prolog",
				"promql",
				"properties",
				"proto",
				"prql",
				"psv",
				"pug",
				"puppet",
				"purescript",
				"pymanifest",
				"python",
				"ql",
				"qmldir",
				"qmljs",
				"query",
				"r",
				"racket",
				"ralph",
				"rasi",
				"razor",
				"rbs",
				"re2c",
				"readline",
				"regex",
				"rego",
				"requirements",
				"rescript",
				"rnoweb",
				"robot",
				"robots",
				"roc",
				"ron",
				"rst",
				"ruby",
				"runescript",
				"rust",
				"scala",
				--error "scfg",
				"scheme",
				"scss",
				"sflog",
				"slang",
				"slim",
				"slint",
				"smali",
				"snakemake",
				"smithy",
				"solidity",
				"soql",
				"sosl",
				"sourcepawn",
				"sparql",
				"sql",
				"squirrel",
				"ssh_config",
				"starlark",
				"strace",
				"styled",
				"supercollider",
				"superhtml",
				"surface",
				"svelte",
				"sway",
				--error "swift",
				"sxhkdrc",
				"systemtap",
				"t32",
				"tablegen",
				"tact",
				--error "teal",
				"tcl",
				"tera",
				"terraform",
				"textproto",
				"thrift",
				"tiger",
				"tlaplus",
				"tmux",
				"todotxt",
				"toml",
				"tsv",
				"tsx",
				"turtle",
				"twig",
				"typescript",
				"typespec",
				"typoscript",
				"typst",
				"udev",
				"ungrammar",
				--error "unison",
				"usd",
				"uxntal",
				"v",
				"vala",
				"vento",
				"verilog",
				"vhdl",
				"vhs",
				"vim",
				"vimdoc",
				"vrl",
				"vue",
				"wgsl",
				"wgsl_bevy",
				"wing",
				"wit",
				"xcompose",
				"xml",
				"xresources",
				"yaml",
				"yang",
				"yuck",
				"zathurarc",
				"zig",
				"ziggy",
				"ziggy_schema",
				"templ",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = false, disable = { "ruby" } },
		},
		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	},

	-- Adds tabline (for buffer visibility).
	{ -- akinsho/bufferline.nvim
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					numbers = "buffer_id",
					--mode = "tabs",
					close_command = "Bdelete %d",
					left_mouse_command = "buffer %d",
					right_mouse_command = "",
					middle_mouse_command = "",
					indicator = { style = "icon" },
					buffer_close_icon = "󰅖",
					modified_icon = "●",
					close_icon = "",
					left_trunc_marker = "",
					right_trunc_marker = "",
					max_name_length = 18,
					max_prefix_length = 15,
					truncate_names = true,
					tab_size = 18,
					offsets = {
						{
							filetype = "neo-tree",
							text = "Neo-tree",
							highlight = "Directory",
							text_align = "left",
						},
					},
					color_icons = true,
					show_buffer_icons = true,
					show_close_icon = true,
					show_tab_indicators = true,
					persist_buffer_sort = true,
					separator_style = "slant",
					enforce_regular_tabs = false,
					always_show_bufferline = true,
				},
			})
		end,
	},

	-- Newer (and better?) than nvim-tree.
	-- Note: The persistant sidebar behavior comes from bufferline offsets, not neo-tree.
	-- Note: New tabs without bufferline will keep neo-tree on a single tab. Bufferline
	--       can also be configured with this behavior.
	{ -- nvim-neo-tree/neo-tree.nvim
		"nvim-neo-tree/neo-tree.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		lazy = false,
		keys = {
			-- Defined in the keymap section above
			--			{ "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
		},
		opts = {
			close_if_last_window = true,
			popup_border_style = "rounded",
			use_popups_for_input = false,

			window = {
				position = "left",
				width = 35,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
			},

			filesystem = {
				follow_current_file = { enabled = true },
				hijack_netrw_behavior = "open_default",
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				window = {
					mappings = {
						["\\"] = "close_window",
					},
				},
			},

			buffers = {
				follow_current_file = { enabled = true },
				group_empty_dirs = true,
				show_unloaded = true,
			},

			git_status = {
				window = {
					position = "float",
				},
			},
		},
	},
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
