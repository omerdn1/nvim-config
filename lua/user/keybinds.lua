vim.g.mapleader = " "

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Leader>w", "<C-w>k")
vim.keymap.set("n", "<Leader>a", "<C-w>h")
vim.keymap.set("n", "<Leader>s", "<C-w>j")
vim.keymap.set("n", "<Leader>d", "<C-w>l")
vim.keymap.set("n", "<Leader>k", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<Leader>j", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<Leader>q", ":bprevious<CR>:bdelete #<CR>", { silent = true })
vim.keymap.set("n", "<Leader>/", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<Leader>y", ":%y<CR>")
vim.keymap.set("n", "k", "gk", { silent = true })
vim.keymap.set("n", "j", "gj", { silent = true })
vim.keymap.set("t", "<Leader><Esc>", "<C-\\><C-n>", { silent = true })
vim.keymap.set("n", "<Leader>v", ":edit ~/.config/nvim/init.lua<CR>", { silent = true })

vim.keymap.set("n", "<Leader>n", require("telescope").extensions.file_browser.file_browser)
vim.keymap.set("n", "<Leader>p", require("telescope.builtin").find_files)
vim.keymap.set("n", "<Leader>t", require("telescope.builtin").treesitter)

vim.keymap.set("n", "<Leader>f", function(path)
	require("telescope.builtin").live_grep({ search_dirs = { path or vim.fn.input("Dir: ", "./", "dir") } })
end)

-- Inverse tab with Shift-Tab
vim.keymap.set("i", "<S-Tab>", "<C-d>")
vim.keymap.set({ "n", "v" }, "<Leader>c", ":Commentary<CR>", { silent = true })

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

function _lazygit_toggle()
	lazygit:toggle()
end

vim.keymap.set("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

-- vim.keymap.set("n", "<leader>g", ":FloatermNew lazygit<CR>")

-- Terminal management
-- _G.term_buf_of_tab = _G.term_buf_of_tab or {}
-- _G.term_buf_max_nmb = _G.term_buf_max_nmb or 0

-- function spawn_terminal()
-- 	local cur_tab = vim.api.nvim_get_current_tabpage()
-- 	vim.cmd("split | terminal")
-- 	local cur_buf = vim.api.nvim_get_current_buf()
-- 	_G.term_buf_max_nmb = _G.term_buf_max_nmb + 1
-- 	vim.api.nvim_buf_set_name(cur_buf, "Terminal " .. _G.term_buf_max_nmb)
-- 	table.insert(_G.term_buf_of_tab, cur_tab, cur_buf)
-- 	vim.cmd(":startinsert")
-- end

-- function toggle_terminal()
-- 	local cur_tab = vim.api.nvim_get_current_tabpage()
-- 	local term_buf = term_buf_of_tab[cur_tab]
-- 	if term_buf ~= nil then
-- 		local cur_buf = vim.api.nvim_get_current_buf()
-- 		if cur_buf == term_buf then
-- 			vim.cmd("q")
-- 		else
-- 			vim.cmd("sb" .. term_buf) -- "vert sb" for vsplit
-- 			vim.cmd(":startinsert")
-- 		end
-- 	else
-- 		spawn_terminal()
-- 		vim.cmd(":startinsert")
-- 	end
-- end
-- vim.keymap.set("n", "<c-`>", toggle_terminal)
-- vim.keymap.set("i", "<c-`>", "<ESC>:lua toggle_terminal()<CR>")
-- vim.keymap.set("t", "<c-`>", "<c-\\><c-n>:lua toggle_terminal()<CR>")
--

-- Test, Build and Run keybindings for different languages
-- Test = <Leader>-t
-- Build = <Leader>-b
-- Run = <Leader>-r
local lang_maps = {
	cpp = { build = "g++ % -o %:r", exec = "./%:r" },
	-- typescript = { build = "deno compile %", exec = "deno run %" },
	-- javascript = { build = "deno compile %", exec = "deno run %" },
	python = { exec = "python %" },
	java = { build = "javac %", exec = "java %:r" },
	sh = { exec = "./%" },
	go = { build = "go build", exec = "go run %" },
	rust = { test = "cargo test", exec = "cargo run" },
}
for lang, data in pairs(lang_maps) do
	if data.test ~= nil then
		vim.api.nvim_create_autocmd(
			"FileType",
			{ command = "nnoremap <Leader>t :split<CR>:terminal " .. data.test .. "<CR>", pattern = lang }
		)
	end
	if data.build ~= nil then
		vim.api.nvim_create_autocmd(
			"FileType",
			{ command = "nnoremap <Leader>b :!" .. data.build .. "<CR>", pattern = lang }
		)
	end
	vim.api.nvim_create_autocmd(
		"FileType",
		{ command = "nnoremap <Leader>r :split<CR>:terminal " .. data.exec .. "<CR>", pattern = lang }
	)
end
