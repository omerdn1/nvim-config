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
	-- CMP Plugins
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/vim-vsnip")
	-- Vim Enhancements
	use("mg979/vim-visual-multi")
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			vim.g.indent_blankline_show_first_indent_level = false
			vim.g.indent_blankline_show_trailing_blankline_indent = false
		end,
	})
	use({ "ggandor/leap.nvim", config = { require("leap").set_default_keymaps() } })
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
		tag = "v2.*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-`>]],
			})
		end,
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
		tag = "v2.*",
		requires = "kyazdani42/nvim-web-devicons",
	})

	use("simrat39/rust-tools.nvim")

	use("sainnhe/edge")
	use("nvim-treesitter/nvim-treesitter")
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

require("bufferline").setup({
	options = {
		sort_by = "insert_after_current",
	},
})

require("gitsigns").setup()

require("telescope").setup({
	defaults = {
		mappings = { n = { ["o"] = require("telescope.actions").select_default } },
		initial_mode = "insert",
		hidden = true,
		file_ignore_patterns = { ".git/", "node_modules/", "target/" },
	},
	extensions = { file_browser = { hidden = true } },
})
require("telescope").load_extension("file_browser")

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
})
