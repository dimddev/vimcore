set runtimepath+=~/.vim/plugged/gruvbox

set background=dark
colorscheme gruvbox

set guicursor=
set termguicolors

" Basic Settings
set nocompatible              " Be iMproved, required to enable Vim features
filetype off                  " Disable filetype detection for now (plugin manager may override later)
set encoding=utf-8            " Use UTF-8 encoding for proper text handling
set splitright                " Open vertical splits to the right of the current window

" Tab and Indentation Settings
set expandtab                 " Use spaces instead of tabs
set softtabstop=4             " Number of spaces per Tab press in insert mode
set tabstop=4                 " Number of spaces that a Tab represents
set shiftwidth=2              " Indentation width when using >> or << commands
set autoindent                " Copy indent from the previous line

" Display Line Numbers
set number                    " Show absolute line numbers
" set relativenumber            " Show relative line numbers for easy navigation

" Cursor and Highlighting
set cursorline                " Highlight the line where the cursor is
set synmaxcol=300             " Limit syntax highlighting to 300 columns for performance
set hlsearch                  " Highlight search matches
set incsearch                 " Incrementally highlight search matches as you type

" Line Wrapping and Case Sensitivity
set nowrap                    " Disable line wrapping for better code readability
set smartcase                 " Case-insensitive search unless an uppercase letter is used

" Backup and Swap Settings
set backupcopy=yes            " Overwrite files when saving (fixes certain issues with symlinks)
set autoread                  " Automatically reload files if they are changed outside Vim

" History and Performance
set history=3000              " Keep a history of the last 1000 commands
set updatetime=7500           " Time in milliseconds for triggering events (e.g., CursorHold)
set lazyredraw                " Improve performance by delaying screen redraws during macros

" Scrolling Behavior
set scrolloff=5               " Keep 5 lines above/below the cursor when scrolling
set sidescrolloff=5           " Keep 5 columns to the left/right of the cursor when scrolling

" Enable Mouse Support
set mouse=a                   " Allow mouse usage for resizing splits, selecting text, etc.

" Color and GUI
set termguicolors             " Enable true color support for better themes
set signcolumn=yes            " Always show the sign column (useful for diagnostics/linting)

" Timeout Settings for Key Mappings
set timeoutlen=500            " Set timeout length for mapped commands (ms)
set ttimeoutlen=50            " Set timeout length for keycode sequences (ms)

" Persistent Buffers
set hidden                    " Allow switching buffers without saving changes

" Command-Line Completion
set wildmenu                  " Enable enhanced command-line completion
set wildmode=list:longest,full " Show options in a list and autocomplete the longest common part

set statusline+=%#warningmsg#
set statusline+=%{virtualenv#statusline()}
set statusline+=%*

" Marks and undo
set undofile
set undodir=~/.cache/vim/undo

" ***********************************************************
" SPELL SETTINGS
setlocal spell spelllang=en

" ***********************************************************
" RUNTIME VIM MACROS
runtime macros/matchit.vim

" ***********************************************************
" THE PLUGIN LOADER IS **PLUG**
call plug#begin('~/.vim/plugged')

" ***********************************************************************************
" GLOBAL PLUGINS

Plug 'morhetz/gruvbox'
Plug 'Raimondi/delimitMate'
Plug 'bronson/vim-trailing-whitespace'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'easymotion/vim-easymotion'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'


" ALL OF YOUR PLUGINS MUST BE ADDED BEFORE THE FOLLOWING LINE
call plug#end() " initialize plugin system

" Autocommands
autocmd FocusLost * silent! wa " Auto-save all files when Vim loses focus
autocmd FileType markdown,text setlocal wrap " Enable line wrapping for Markdown and plain text
autocmd BufLeave,QuitPre * silent! wa


" Leader Key Mappings
nnoremap <leader>w :w<CR>     " Save the file with <leader>w
nnoremap <leader>q :q<CR>     " Quit Vim with <leader>q
nnoremap <leader>x :x<CR>     " Save and quit with <leader>x

" ***********************************************************
" AUTOMATICALLY LEAVE INSERT MODE,
" AFTER 'updatetime' MILLISECONDS OF INACTION
au CursorHoldI * stopinsert

" ***********************************************************
" background of auto suggesting menu
hi Pmenu        ctermfg=white ctermbg=black gui=NONE guifg=white guibg=black
hi PmenuSel     ctermfg=white ctermbg=blue gui=bold guifg=white guibg=purple

" ***********************************************************
" Turn off arrows.
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" ***********************************************************
" SHORTCUTS
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>

nnoremap <silent> <leader><space> :Files<CR>
nnoremap <silent> <leader>a :Buffers<CR>
nnoremap <silent> <leader>A :Windows<CR>
nnoremap <silent> <leader>; :BLines<CR>
nnoremap <silent> <leader>? :History<CR>

nnoremap <leader>0 :g/^[^0-9]/s/^/\=line('.') . '. '/<CR>

" ***********************************************************************************
" SPELLING RULES
fun! SetSpellingColors()
  highlight SpellBad cterm=bold ctermfg=white ctermbg=red
  highlight SpellCap cterm=bold ctermfg=red ctermbg=white
endfun

augroup spellrulez
  autocmd!
  autocmd BufWinEnter *.txt,*.md call SetSpellingColors()
  autocmd BufNewFile *.txt,*.md call SetSpellingColors()
  autocmd BufRead *.txt,*.md call SetSpellingColors()
  autocmd InsertEnter *.txt,*.md call SetSpellingColors()
  autocmd InsertLeave *.txt,*.md call SetSpellingColors()
  autocmd BufWritePost *.txt,*.md call SetSpellingColors()
augroup END

" ***********************************************************************************
" EASY MOTION
let g:EasyMotion_do_mapping = 0 " Disable default mappings

nmap s <Plug>(easymotion-overwin-f2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" ***********************************************************************************
" AIRLINE THEME
let g:airline_theme='murmur'
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1

" Search with ripgrep within files. Use :Rg
command! -nargs=* Rg call fzf#vim#grep(
    \ 'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
    \ 1,
    \ fzf#vim#with_preview(),
    \ <bang>0)

