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
	-- CMP Plugins
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/vim-vsnip")
	-- Git
	use("lewis6991/gitsigns.nvim")
	-- Terminal Management
	use("voldikss/vim-floaterm")
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
				tabline = {
					lualine_a = { "buffers" },
				},
			}),
		},
	})

	use("navarasu/onedark.nvim") -- Theme inspired by Atom's One
	use("nvim-treesitter/nvim-treesitter")
	use("tpope/vim-commentary")
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use("nvim-telescope/telescope-file-browser.nvim")
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)

require("onedark").setup({
	style = "deep",
})
vim.cmd([[ colorscheme onedark ]])

require("gitsigns").setup()

require("telescope").setup({
	defaults = {
		mappings = { n = { ["o"] = require("telescope.actions").select_default } },
		initial_mode = "normal",
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
})
