" Leader Key
let mapleader=" "

" Interface and Display Settings
set visualbell " Use visual bell (no beeping)
set relativenumber " Show relative line numbers
set nu " Show absolute line number for the current line
set scrolloff=10 " Keep at least 10 lines above/below the cursor
set incsearch " Incremental search
set hlsearch " Highlight search results
set title " Set window title to file name
set cursorline " Highlight the current line

" Tab and Indentation Settings
set tabstop=2 " Number of spaces that a tab character represents
set shiftwidth=2 " Width for autoindents
set softtabstop=2 " Number of spaces per Tab
set autoread " Auto-read files when modified outside Vim

" Clear search highlight when pressing escape
map <esc> :noh<cr>

" Normal Mode Remaps
nnoremap <C-q> <C-v> " C-q visual select multiple lines
nnoremap J mzJ`z " keep the cursor where it should be after C-j
nnoremap <C-d> <C-d>zz " keep cursor in the middle
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Pane Navigation
nnoremap <A-h> <C-w>h
nnoremap <A-l> <C-w>l
nnoremap <A-k> <C-w>k
nnoremap <A-j> <C-w>j

" Visual Mode Enhancements
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap < <gv
vnoremap > >gv

" === IDEA VIM ==="

" Go to Actions
nmap gd <Action>(GotoDeclaration)
nmap gy <Action>(GotoTypeDeclaration)
nmap gi <Action>(GotoImplementation)
nmap gr <Action>(ShowUsages)
nmap gt <Action>(GotoTest)
nmap gb <Action>(Back)
nmap gf <Action>(Forward)
nmap [[ <Action>(MethodUp)
nmap ]] <Action>(MethodDown)

" Map IDE functions
map <C-s> <Action>(CommentByLineComment)
map <S-Space> <Action>(ReSharperGotoNextErrorInSolution)
map <leader>h <Action>(ReformatCode)
map <leader>g <Action>(SilentCodeCleanup)
map <leader>r <Action>(RenameElement)
map <leader>d <Action>(Debug)
map <leader>b <Action>(ToggleLineBreakpoint)
map <leader>q <action>(CloseContent)

" WhichKey and Timeout Settings
set which-key
set timeoutlen=5000

