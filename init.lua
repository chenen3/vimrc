vim.cmd[[
filetype plugin on
filetype indent on
autocmd FileType python let &colorcolumn="80"
autocmd FileType go let &colorcolumn="100"

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
command! TrimWhitespace call TrimWhitespace()
]]

vim.bo.shiftwidth = 4
vim.bo.tabstop= 4
vim.bo.smartindent = true
vim.wo.number = true
vim.wo.cursorline = true
vim.bo.swapfile = false
vim.go.backup = false
vim.go.writebackup = false
vim.go.guifont = 'Menlo:h14'
vim.go.ignorecase = true
vim.go.smartcase = true
vim.go.incsearch = true
vim.go.lazyredraw = true
vim.go.showmatch = true
vim.go.pumheight = 10
vim.go.splitright = true
vim.go.splitbelow = true
vim.go.timeoutlen = 500
vim.go.history = 700
vim.go.wildignore = '*.o,*~,*.pyc'

vim.g.mapleader = ','
vim.keymap.set('n', '<leader>ss', '<CMD>setlocal spell!<CR>') -- toggle spell checking
vim.keymap.set('n', '<leader>q', '<CMD>q<CR>') -- exit buffer
vim.keymap.set('n', '0', '^') -- move to first non-blank character
vim.keymap.set('x', 'p', 'pgvy') -- prepare for the second pasting
vim.keymap.set('i', "'", "''<ESC>i")
vim.keymap.set('i', '"', '""<ESC>i')
vim.keymap.set('i', '(', '()<ESC>i')
vim.keymap.set('i', '(', '()<ESC>i')
vim.keymap.set('i', '{', '{}<ESC>i')
vim.keymap.set('i', '[', '[]<ESC>i')
vim.keymap.set('n', 'j', 'gj') -- treat long lines as break lines (useful when moving around in them)
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', '<C-W>>', '<CMD>vertical resize +10<CR>')
vim.keymap.set('n', '<C-W><', '<CMD>vertical resize -10<CR>')

require('plugin')
