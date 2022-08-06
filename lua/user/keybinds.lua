vim.g.mapleader = " "

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Leader>w", "<C-w>k")
vim.keymap.set("n", "<Leader>a", "<C-w>h")
vim.keymap.set("n", "<Leader>s", "<C-w>j")
vim.keymap.set("n", "<Leader>d", "<C-w>l")
vim.keymap.set("n", "<Leader>j", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<Leader>k", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<Leader>q", ":bprevious<CR>:bdelete #<CR>", { silent = true })
vim.keymap.set("n", "<Leader>/", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<Leader>y", ":%y<CR>")
vim.keymap.set("n", "k", "gk", { silent = true })
vim.keymap.set("n", "j", "gj", { silent = true })
vim.keymap.set("n", "<Leader>l", ":vsplit term://fish <CR>", { silent = true })
vim.keymap.set("t", "<Leader><Esc>", "<C-\\><C-n>", { silent = true })
vim.keymap.set("n", "<Leader>v", ":edit ~/.config/nvim/init.lua<CR>", { silent = true })

vim.keymap.set("n", "<Leader>n", require("telescope").extensions.file_browser.file_browser)
vim.keymap.set("n", "<Leader>f", require("telescope.builtin").find_files)
vim.keymap.set("n", "<Leader>t", require("telescope.builtin").treesitter)

vim.keymap.set({ "n", "v" }, "<Leader>c", ":Commentary<CR>", { silent = true })

vim.keymap.set("n", "<leader>g", ":FloatermNew lazygit<CR>")

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
