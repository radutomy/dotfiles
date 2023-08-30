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

set number							" relative numbers instead of absolute
set hlsearch						" highlights all occurances of a word in search
set tabstop=2
set shiftwidth=2
set softtabstop=2				" num of spaces a tab counts when editing
set showcmd							" last command entered in vim
set showmatch						" show matching paranthesis
set title								" sets the title to the current open file
set paste								" fixes indentation when pasting from global clipboard
set ignorecase
set smartcase
set clipboard=unnamed 	" lets vim use global clipboard
set mouse=a
set ls=0								" remove neovim status bar

syntax enable								" enable vim syntax highlighting
colorscheme peachpuff				" best color scheme in the known universe

"-----------------------------"
" VIM - AUTOMATION
"-----------------------------"

" Both absolute and relative line numbers are enabled by default, which produces “hybrid” line numbers. 
" When entering insert mode, relative line numbers are turned off, leaving absolute line numbers turned on. 
" This also happens when the buffer loses focus, so you can glance back at it to see which absolute line you were working on if you need to.
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
:augroup END

"-----------------------------"
" VIM - MAPPINGS
"-----------------------------"

nnoremap <silent> <CR> :noh<CR>		" press ENTER to clear highlighted word search
nnoremap <silent> <C-l> :set nu! rnu!<CR>	" toggle line numbers on/ff
nnoremap <silent> <C-s> :if &mouse == "a" \| set mouse= \| else \| set mouse=a \| endif<CR>

map <C-Left> b
map <C-Right> w

" Scroll the view up by one line without moving the cursor
map <C-Up> <C-Y>
map <C-Down> <C-E>

