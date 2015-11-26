set nocompatible

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/vundle'
Plugin 'elzr/vim-json'
Plugin 'lepture/vim-javascript'
Plugin 'Shougo/vimproc'
Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'Raimondi/delimitMate'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'crusoexia/vim-monokai'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-surround'
Plugin 'Yggdroot/indentLine'
Plugin 'tpope/vim-repeat'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'marijnh/tern_for_vim'
Plugin 'maksimr/vim-jsbeautify'
Plugin 'einars/js-beautify'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'walm/jshint.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'derekwyatt/vim-scala'
Plugin 'klen/python-mode'
Plugin 'mhinz/vim-startify'
Plugin 'mileszs/ack.vim'
Plugin 'rking/ag.vim'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

call vundle#end()
filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ctrlp
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)|node_modules$|bower_components|vender',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_working_path_mode = 'ra'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"colorscheme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    colorscheme solarized "candidate: monokai,solarized
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme desert
endtry

if has("gui_running")
    try
        set guifont=Ubuntu\ Mono\ derivative\ Powerline:h14
    endtry
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indentline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:indentLine_color_term = 239
" To be compatible with vim-json
let g:indentLine_noConcealCursor=""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F2> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") &&  b:NERDTreeType == "primary") | q | endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" jsbeautify
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType javascript noremap <buffer> <leader>f :call JsBeautify()<cr>
autocmd FileType javascript vnoremap <buffer> <leader>f :call RangeJsBeautify()<cr>
autocmd FileType html noremap <buffer> <leader>f :call HtmlBeautify()<cr>
autocmd FileType html vnoremap <buffer> <leader>f :call RangeHtmlBeautify()<cr>
autocmd FileType css noremap <buffer> <leader>f :call CSSBeautify()<cr>
autocmd FileType css vnoremap <buffer> <leader>f :call RangeCSSBeautify()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" youcompleteme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>jf :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>jg :YcmCompleter GoToDefinitionElseDeclaration<CR>

let g:ycm_path_to_python_interpreter = '/usr/bin/python'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf=0
let g:ycm_collect_identifiers_from_tag_files = 1
let g:ycm_filetype_blacklist = {
            \ 'tagbar' : 1,
            \ 'qf' : 1,
            \ 'notes' : 1,
            \ 'markdown' : 1,
            \ 'unite' : 1,
            \ 'text' : 1,
            \ 'vimwiki' : 1,
            \ 'gitcommit' : 1,
            \}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntastic
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_wq = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" powerline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set laststatus=2
let g:Powerline_symbols = 'fancy'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSApprox
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256
let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" easymotion
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" markdown
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vim_markdown_folding_disabled=1
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tern
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>d :TernDef<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" monokai
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:monokai_italic = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" python-mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:pymode_folding = 0
let g:pymode_lint_cwindow = 0
let g:pymode_lint_ignore = "E501,E265,W"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" code search : ag & ack
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ag_highlight=1
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif
