local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap =
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd([[packadd packer.nvim]])
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

require("packer").startup(function(use)
	-- My plugins here
	use("wbthomason/packer.nvim")

	use("lewis6991/impatient.nvim")

	--- LSP
	use("neovim/nvim-lspconfig") -- Configurations for Nvim LSP
	use({ "williamboman/nvim-lsp-installer", config = { require("nvim-lsp-installer").setup({}) } }) -- LSP Server Installer
	use("jose-elias-alvarez/null-ls.nvim")
	use({
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		config = function()
			require("lsp_lines").setup()
		end,
	})
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({
				text = {
					spinner = "moon",
				},
				align = {
					bottom = true,
				},
				window = {
					relative = "editor",
				},
			})
		end,
	})
	-- CMP Plugins
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/vim-vsnip")
	use("onsails/lspkind-nvim")
	require("user/cmp_gh_source")
	use("Exafunction/codeium.vim")
	-- use({ "saadparwaiz1/cmp_luasnip" })
	use({ "L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*" })
	-- Vim Enhancements
	use("vim-scripts/BufOnly.vim")
	use({
		"mg979/vim-visual-multi",
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			vim.g.indent_blankline_show_first_indent_level = false
			vim.g.indent_blankline_show_trailing_blankline_indent = false
		end,
	})
	use({ "ggandor/leap.nvim", config = { require("leap").set_default_keymaps() } })
	-- More useful word motions
	-- use("chaoren/vim-wordmotion")
	-- Keybindings
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	})
	-- Git
	use("lewis6991/gitsigns.nvim")
	-- Terminal Management
	-- use("voldikss/vim-floaterm")
	use({
		"akinsho/toggleterm.nvim",
		-- tag = "v2.*",
	})
	-- Session Management
	use({
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			})
		end,
	})
	-- UI
	use("kyazdani42/nvim-web-devicons")
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = {
			require("lualine").setup({
				options = {
					theme = "gruvbox",
					icons_enabled = true,
				},
				sections = {
					lualine_c = { { "filename", path = 1 } },
				},
				-- tabline = {
				-- 	lualine_a = { "buffers" },
				-- },
			}),
		},
	})
	use({
		"akinsho/bufferline.nvim",
		-- tag = "v2.*",
		requires = "kyazdani42/nvim-web-devicons",
	})
	-- Window Management
	-- use("mrjones2014/smart-splits.nvim")
	use({
		"anuvyklack/hydra.nvim",
		requires = {
			"sindrets/winshift.nvim",
			"anuvyklack/windows.nvim",
			"anuvyklack/middleclass",
			"anuvyklack/animation.nvim",
			"mrjones2014/smart-splits.nvim",
		},
		config = function()
			vim.o.winwidth = 10
			vim.o.winminwidth = 10
			vim.o.equalalways = false
			require("winshift").setup()
			require("windows").setup()
			-- require("smart-splits").setup()
		end,
	})
	-- use({
	-- 	"anuvyklack/windows.nvim",
	-- 	requires = {
	-- 		"anuvyklack/middleclass",
	-- 		"anuvyklack/animation.nvim",
	-- 	},
	-- 	config = function()
	-- 		vim.o.winwidth = 10
	-- 		vim.o.winminwidth = 10
	-- 		require("windows").setup()
	-- 	end,
	-- })

	use("simrat39/rust-tools.nvim")
	use({ "akinsho/flutter-tools.nvim", requires = "nvim-lua/plenary.nvim" })

	use("sainnhe/edge")
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
		},
		tag = "nightly", -- optional, updated every week. (see issue #1193)
	})
	use("nvim-treesitter/nvim-treesitter")
	use("nvim-treesitter/nvim-treesitter-context")
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("tpope/vim-commentary")
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use("nvim-telescope/telescope-file-browser.nvim")
	use({ "stevearc/dressing.nvim" })
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})
	use({ "windwp/nvim-ts-autotag" })
	use({
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup({})
		end,
	})
	use("p00f/nvim-ts-rainbow")
	use("zefei/vim-colortuner")
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)

-- vim.cmd([[ colorscheme onedark ]])
--

-- let g:edge_style = 'aura'
-- vim.g.edge_style = "neon"
-- vim.g.edge_diagnostic_virtual_text = "colored"
-- vim.cmd([[ colorscheme edge ]])

require("gitsigns").setup()

-- empty setup using defaults
require("nvim-tree").setup()

require("telescope").setup({
	defaults = {
		mappings = { n = { ["o"] = require("telescope.actions").select_default } },
		initial_mode = "insert",
		hidden = true,
		file_ignore_patterns = { ".DS_Store", ".git/", "node_modules/", "target/" },
	},
	pickers = { find_files = { hidden = true } },
	extensions = { file_browser = { depth = false, hidden = true } },
})
require("telescope").load_extension("file_browser")
require("telescope").load_extension("flutter")

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"cpp",
		"css",
		"go",
		"html",
		"lua",
		"make",
		"python",
		"rust",
		"tsx",
		"typescript",
		"yaml",
	},
	highlight = { enable = true },
	autotag = { enable = true },
	rainbow = { enable = true, extended_mode = true },
	textobjects = {
		move = {
			enable = true,
			set_jumps = true,

			goto_next_start = {
				["]p"] = "@parameter.inner",
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[p"] = "@parameter.inner",
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},

		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",

				["ac"] = "@conditional.outer",
				["ic"] = "@conditional.inner",

				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",

				["av"] = "@variable.outer",
				["iv"] = "@variable.inner",
			},
		},

		swap = {
			enable = true,
			swap_next = {
				["<leader><leader>s"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader><leader>S"] = "@parameter.inner",
			},
		},

		lsp_interop = {
			enable = true,
			border = "none",
			peek_definition_code = {
				["<leader><leader>h"] = "@function.outer",
				["<leader><leader>H"] = "@class.outer",
			},
		},
	},
})

require("treesitter-context").setup({
	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	throttle = true, -- Throttles plugin updates (may improve performance)
	max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
	-- show_all_context = show_all_context,
	patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
		-- For all filetypes
		-- Note that setting an entry here replaces all other patterns for this entry.
		-- By setting the 'default' entry below, you can control which nodes you want to
		-- appear in the context window.
		default = {
			"function",
			"method",
			"for",
			"while",
			"if",
			"switch",
			"case",
		},

		rust = {
			"loop_expression",
			"impl_item",
			"type",
			"macro",
			"mod",
		},

		typescript = {
			"class_declaration",
			"abstract_class_declaration",
			"else_clause",
		},
	},
})

-- Setup window management
local Hydra = require("hydra")
local splits = require("smart-splits")
local cmd = require("hydra.keymap-util").cmd
local pcmd = require("hydra.keymap-util").pcmd

local window_hint = [[
 ^^^^^^^^^^^^     Move      ^^    Size   ^^   ^^     Split
 ^^^^^^^^^^^^-------------  ^^-----------^^   ^^---------------
 ^ ^ _k_ ^ ^  ^ ^ _K_ ^ ^   ^   _<C-k>_   ^   _s_: horizontally 
 _h_ ^ ^ _l_  _H_ ^ ^ _L_   _<C-h>_ _<C-l>_   _v_: vertically
 ^ ^ _j_ ^ ^  ^ ^ _J_ ^ ^   ^   _<C-j>_   ^   _q_, _c_: close
 focus^^^^^^  window^^^^^^  ^_=_: equalize^   _z_: maximize
 ^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^   ^^ ^          ^   _o_: remain only
 _b_: choose buffer
]]

Hydra({
	name = "Windows",
	hint = window_hint,
	config = {
		invoke_on_body = true,
		hint = {
			border = "rounded",
			-- offset = -1,
		},
	},
	mode = "n",
	body = "<C-/>",
	heads = {
		{ "h", "<C-w>h" },
		{ "j", "<C-w>j" },
		{ "k", pcmd("wincmd k", "E11", "close") },
		{ "l", "<C-w>l" },

		{ "H", cmd("WinShift left") },
		{ "J", cmd("WinShift down") },
		{ "K", cmd("WinShift up") },
		{ "L", cmd("WinShift right") },

		{
			"<C-h>",
			function()
				splits.resize_left(2)
			end,
		},
		{
			"<C-j>",
			function()
				splits.resize_down(2)
			end,
		},
		{
			"<C-k>",
			function()
				splits.resize_up(2)
			end,
		},
		{
			"<C-l>",
			function()
				splits.resize_right(2)
			end,
		},
		{ "=", "<C-w>=", { desc = "equalize" } },

		{ "s", pcmd("split", "E36") },
		{ "<C-s>", pcmd("split", "E36"), { desc = false } },
		{ "v", pcmd("vsplit", "E36") },
		{ "<C-v>", pcmd("vsplit", "E36"), { desc = false } },

		{ "w", "<C-w>w", { exit = true, desc = false } },
		{ "<C-w>", "<C-w>w", { exit = true, desc = false } },

		{ "z", cmd("WindowsMaximaze"), { exit = true, desc = "maximize" } },
		{ "<C-z>", cmd("WindowsMaximaze"), { exit = true, desc = false } },

		{ "o", "<C-w>o", { exit = true, desc = "remain only" } },
		{ "<C-o>", "<C-w>o", { exit = true, desc = false } },

		{
			"b",
			function()
				print("Implement buffer function")
			end,
			{ exit = true, desc = "choose buffer" },
		},

		{ "c", pcmd("close", "E444") },
		{ "q", pcmd("close", "E444"), { desc = "close window" } },
		{ "<C-c>", pcmd("close", "E444"), { desc = false } },
		{ "<C-q>", pcmd("close", "E444"), { desc = false } },

		{ "<Esc>", nil, { exit = true, desc = false } },
	},
})

vim.opt.mousemoveevent = true

require("bufferline").setup({
	options = {
		-- persist_buffer_sort = false,
		sort_by = "insert_after_current",
		diagnostics = "nvim_lsp",
		indicator = {
			-- Only works well with Terminals that support nice underlines
			style = "underline",
		},
		hover = {
			enabled = true,
			delay = 100,
			reveal = { "close" },
		},
	},
})

require("toggleterm").setup({
	open_mapping = [[<c-`>]],
	persist_mode = true,
	start_in_insert = true,
	-- persist_size = false,
})

-- Configure LuaSnip
local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.set_config({
	-- This tells LuaSnip to remember to keep around the last snippet.
	-- You can jump back into it even if you move outside of the selection
	history = true,

	-- This one is cool cause if you have dynamic snippets, it updates as you type!
	updateevents = "TextChanged,TextChangedI",

	-- Autosnippets:
	enable_autosnippets = true,

	-- Crazy highlights!!
	-- #vid3
	-- ext_opts = nil,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { " « ", "NonTest" } },
			},
		},
	},
})

for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/user/snips/*.lua", true)) do
	loadfile(ft_path)()
end

-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2)
vim.keymap.set("i", "<c-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)
