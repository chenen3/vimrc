-- Options
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.splitright = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Files & Backups
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Appearance
vim.cmd.colorscheme("shine")

-- Mappings
local keymap = vim.keymap.set

-- Remap 0 to first non-blank character
keymap("", "0", "^")

-- Paste in visual mode without overwriting register
keymap("x", "p", "pgvy")

-- Quick save and quit
keymap("i", "<C-x>", "<Esc>:x<CR>")
keymap("n", "<C-x>", ":x<CR>")
keymap("n", "<C-q>", ":q<CR>")

-- Last position jump (from our previous discussion)
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
