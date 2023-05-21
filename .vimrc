"-----------------------------"
" VIM PLUG - SETUP              " 
"-----------------------------" 

"call plug#begin('~/.vim/plugged')

"Plug 'ekalinin/Dockerfile.vim'
"Plug 'itchyny/lightline.vim'
"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'
"Plug 'voldikss/vim-floaterm'

"call plug#end()

"-----------------------------"
" VIM - CONFIGURATION
"-----------------------------"

filetype plugin indent on

set number relativenumber	" relative numbers instead of absolute
set hlsearch			" highlights all occurances of a word in search
set tabstop=2
set shiftwidth=2
set softtabstop=2		" num of spaces a tab counts when editing
set showcmd			" last command entered in vim
set showmatch			" show matching paranthesis
set title			" sets the title to the current open file
set paste			" fixes indentation when pasting from global clipboard
set ignorecase
set smartcase
colorscheme peachpuff		" best color scheme in the known universe
syntax enable			" enable vim syntax highlighting

" lets vim use global clipboard
set clipboard=unnamedplus

"-----------------------------"
" VIM - MAPPINGS
"-----------------------------"

" Add syntax support file types
au BufRead,BufNewFile *.conf set filetype=conf
au BufRead,BufNewFile *.bb,*bbclass,*.inc set filetype=bitbake

nnoremap <silent> <C-t> :Files<CR>
nnoremap <silent> <C-r> :Ag<CR>
nnoremap <silent> <C-f> :BLines<CR>
nnoremap <silent> <F1> :FloatermToggle<CR>
nnoremap <silent> <Space> :FloatermNew ranger<CR>
nnoremap <silent> <CR> :noh<CR>						" press ENTER to clear highlighted word search

" Esc key exits the terminal modal window
"autocmd FileType floaterm tnoremap <buffer> <Esc> <C-\><C-n>:bd!<CR>

" Navigate vim panes Alt+Arrow
"nnoremap <M-Down> <C-W><C-J>
"nnoremap <M-Up> <C-W><C-K>
"nnoremap <M-Right> <C-W><C-L>
"nnoremap <M-Left> <C-W><C-H>

"-----------------------------"
" LIGHTLINE - CONFIG
"-----------------------------"

"let lightline = { 'component': { 'filename': '%F', } } " display full file path 
