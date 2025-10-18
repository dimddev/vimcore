" ================================
"  Hakini's Vim — Go-first, Dracula, no ALE
"  (Based on your original .vimrc, carefully cleaned and commented)
" ================================

" ----- Core UI / Terminal behavior -----
set guicursor=                     " Use block cursor in all modes (no GUI cursor shapes)
set termguicolors                  " True color support (needed for Dracula to look right)
set background=dark                " Tell colorschemes we are on a dark background

" ----- Basic editing ergonomics -----
set nocompatible                   " Use Vim (not Vi) features
filetype off                       " Disable filetype for now; we re-enable after plugins are loaded
set encoding=utf-8                 " UTF-8 everywhere
set splitright                     " Vertical splits open to the right

" ----- Indentation & tabs (global defaults) -----
set expandtab                      " Insert spaces when pressing <Tab> (Go buffers override this)
set softtabstop=4                  " How many spaces a <Tab> counts for while editing
set tabstop=4                      " How many spaces a literal <Tab> shows as
set shiftwidth=2                   " Indent/outdent by 2 spaces with >> and <<
set autoindent                     " Copy indent from current line when starting a new line

" ----- Line numbers / highlights -----
set number                         " Show absolute line numbers
set cursorline                     " Highlight the current line
set synmaxcol=300                  " Stop syntax highlighting after column 300 (perf)
set hlsearch                       " Highlight search results
set incsearch                      " Live incremental searching

" ----- Wrapping / search casing -----
set nowrap                         " Don’t soft-wrap long lines
set smartcase                      " Case-insensitive search unless pattern has uppercase

" ----- Files / autoread / history / perf -----
set backupcopy=yes                 " Safer writes over symlinks and some filesystems
set autoread                       " Auto-reload files changed on disk
set autowrite
set history=3000                   " Command/search history size
set updatetime=7500                " CursorHold/CursorHoldI delay (you rely on this for stopinsert)
set lazyredraw                     " Don’t redraw during macros (perf)

" ----- Scrolling behavior -----
set scrolloff=5                    " Keep at least 5 lines above/below cursor
set sidescrolloff=5                " Keep at least 5 columns left/right of cursor

" ----- Mouse -----
set mouse=a                        " Enable mouse (resize splits, select, etc.)

" ----- Mappings timing -----
set timeoutlen=500                 " Timeout for mapped key sequences (ms)
set ttimeoutlen=50                 " Timeout for key codes (ms)

" ----- Buffer behavior -----
set hidden                         " Allow switching buffers with unsaved changes

" ----- Cmdline completion -----
set wildmenu                       " Enhanced :cmd completion menu
set wildmode=list:longest,full     " Show list, insert longest common part, then full completion

" ----- Persistent undo and swap dirs -----
set undofile                       " Persist undo history across sessions
set undodir=~/.cache/vim/undo      " Where to store undo files
set directory=~/.cache/vim/        " Swap file directory

" ----- Signs / diagnostics column -----
set signcolumn=yes                 " Always show sign column (prevents text shifting)

" ----- Built-in macros -----
runtime macros/matchit.vim         " Smarter matching for %, if/else, etc.

" ================================
" Plugin manager: vim-plug
" ================================
call plug#begin('~/.vim/plugged')

" --- Colors / statusline ---
Plug 'dracula/vim', { 'as': 'dracula' }          " Dracula theme
Plug 'vim-airline/vim-airline'                   " Lean status/tab line
Plug 'vim-airline/vim-airline-themes'            " Airline themes (we’ll use Dracula)

" --- Editing helpers ---
Plug 'Raimondi/delimitMate'                      " Auto-close quotes, parens, brackets
Plug 'bronson/vim-trailing-whitespace'           " Highlight and trim trailing spaces
Plug 'tpope/vim-surround'                        " cs, ds, ys for quotes/brackets/tags
Plug 'tpope/vim-sensible'                        " Reasonable baseline defaults
Plug 'tpope/vim-repeat'                          " Make plugin maps repeatable with .
Plug 'tpope/vim-commentary'                      " gcc to comment lines/blocks

" --- Git integration ---
Plug 'tpope/vim-fugitive'                        " :G, :Gblame, :Gdiff, etc.

" --- Motions / Fuzzy finding ---
Plug 'easymotion/vim-easymotion'                 " Quick 2-char motion jumps
Plug 'junegunn/fzf'                              " FZF binary (will self-build if needed)
Plug 'junegunn/fzf.vim'                          " :Files, :Rg, :Buffers, etc.

" --- Languages ---
let g:polyglot_disabled = ['go']                 " Avoid Go conflicts; vim-go will own Go
Plug 'sheerun/vim-polyglot'                      " Extra syntax/indent for many langs (sans Go)

" --- Go (no ALE) ---
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " Go dev: build/test/coverage/rename/etc.
Plug 'SirVer/ultisnips'

" (All plugins must be listed above)
call plug#end()

" ================================
" Colorscheme and syntax (AFTER plug#end)
" ================================
colorscheme dracula               " Use Dracula everywhere
filetype plugin indent on         " Enable filetype detection, plugins, and language indents
syntax on                         " Turn on syntax highlighting

" ================================
" Airline configuration
" ================================
let g:airline_theme = 'dracula'                   " Match airline to Dracula
let g:airline_powerline_fonts = 1                 " Use Powerline symbols if available
let g:airline#extensions#branch#enabled = 1       " Show current Git branch
let g:airline#extensions#tabline#enabled = 1      " Show buffers/tabs on the top bar
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_section_z = '%p%% %{getfsize(expand("%"))}b' " Right section: % + file size

" ================================
" Autocommands
" ================================
autocmd FocusLost * silent! wa                    " Save all on focus loss
autocmd BufLeave,QuitPre * silent! wa             " Save on buffer leave / quit
autocmd FileType markdown,text setlocal wrap      " Wrap only for prose files

" Automatically leave Insert mode after 'updatetime' ms of inactivity.
" You run with a big updatetime to avoid over-eager exits.
au CursorHoldI * stopinsert

" Trim trailing whitespace on save (provided by vim-trailing-whitespace)
autocmd BufWritePre * :FixWhitespace

" Auto-open quickfix window when a quickfix list is produced (e.g., :make, :grep)
autocmd QuickFixCmdPost [^l]* cwindow
autocmd QuickFixCmdPost    l* lwindow

" ================================
" Popup menu (completion) colors
" ================================
hi Pmenu    ctermfg=white ctermbg=black gui=NONE guifg=white guibg=black   " Menu bg/fg
hi PmenuSel ctermfg=white ctermbg=blue  gui=bold guifg=white guibg=purple  " Selected item

" ================================
" Keymaps (no arrow keys + your leaders)
" ================================
" Turn off arrow keys (force hjkl + motions)
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>

" Leader shortcuts
nnoremap <leader>w :w<CR>          " Save
nnoremap <leader>q :q<CR>          " Quit
nnoremap <leader>x :x<CR>          " Save and quit
nnoremap <Leader>b :bp<CR>         " Previous buffer
nnoremap <Leader>f :bn<CR>         " Next buffer
nnoremap <Leader>d :bd<CR>         " Unload buffer

" FZF pickers
nnoremap <silent> <leader><space> :Files<CR>    " Search files in cwd
nnoremap <silent> <leader>a :Buffers<CR>        " Search open buffers
nnoremap <silent> <leader>A :Windows<CR>        " Search windows
nnoremap <silent> <leader>; :BLines<CR>         " Search in current buffer lines
nnoremap <silent> <leader>? :History<CR>        " Command/search history

" Line numbering macro (prefix lines with their numbers)
nnoremap <leader>0 :g/^[^0-9]/s/^/\=line('.') . '. '/<CR>

" EasyMotion core maps (explicit to avoid default mappings)
let g:EasyMotion_do_mapping = 0
nmap s <Plug>(easymotion-overwin-f2)             " 2-char jump in any window
let g:EasyMotion_smartcase = 1                   " Case-smart matches
map <Leader>j <Plug>(easymotion-j)               " Jump down by visual hints
map <Leader>k <Plug>(easymotion-k)               " Jump up by visual hints

" ================================
" FZF + ripgrep integration
" ================================
" Make FZF file lists fast and sensible (include dotfiles; ignore .git/ objects)
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'

" Keep your :Rg but with clear preview and smart-case grep
command! -nargs=* Rg call fzf#vim#grep(
      \ 'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>),
      \ 1,
      \ fzf#vim#with_preview(),
      \ <bang>0)

" ================================
" Go development (vim-go + gopls, no ALE)
" ================================
" Use gopls for definitions/hover/etc. (vim-go delegates to LSP here)
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" Format on save using goimports (adds/removes imports + formats)
let g:go_fmt_command = 'goimports'
let g:go_fmt_autosave = 1

" Testing defaults (show test names; give some time budget)
let g:go_test_show_name = 1
let g:go_test_timeout = '60s'

" Enforce canonical Go indentation per buffer:
"   - tabs (noexpandtab)
"   - visual width 4
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

" Handy Go mappings (buffer-local to Go files)
autocmd FileType go nnoremap <buffer> <leader>gb :GoBuild<CR>           " Build current pkg
autocmd FileType go nnoremap <buffer> <leader>gr :GoRun<CR>             " Run main
autocmd FileType go nnoremap <buffer> <leader>gt :GoTest<CR>            " Run tests in pkg
autocmd FileType go nnoremap <buffer> <leader>gT :GoTestFunc<CR>        " Run test under cursor
autocmd FileType go nnoremap <buffer> <leader>gc :GoCoverageToggle<CR>  " Toggle coverage
autocmd FileType go nnoremap <buffer> <leader>gi :GoImports<CR>         " Fix imports now
autocmd FileType go nnoremap <buffer> <leader>gn :GoRename<CR>          " LSP rename symbol
autocmd FileType go nnoremap <buffer> <leader>gl :GoMetaLinter<CR>      " Run golintrun
autocmd FileType go nnoremap <buffer> <leader>ga :GoAlternate<CR>       " Switch to the test file
autocmd FileType go nnoremap <buffer> <leader>gd :GoDef<CR>             " Switch to the test file
" Optional: auto type info in statusline (can be noisy on very large files)
" let g:go_auto_type_info = 1

" --- vim-go: use golangci-lint for the Tutorial's “Check it” ---
" Show results in the quickfix (vim-go uses location list by default)
let g:go_fmt_command = "goimports"
let g:go_list_type = 'quickfix'          " or 'locationlist' if you prefer

" Tell :GoMetaLinter to use golangci-lint under the hood (vim-go will run `golangci-lint run`)
let g:go_metalinter_command = 'golangci-lint'

" Run the metalinter automatically on save for Go buffers (exactly the “Check it” behavior)
let g:go_metalinter_autosave = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1

" --- Auto-resize quickfix window to 15 lines when it opens ---
augroup qf_resize
  autocmd!
  autocmd FileType qf if winheight(0) < 20 | execute "resize 20" | endif
augroup END

" ********************************************************************************************************
" Transparent editing of GnuPG-encrypted files
" Written by Patrick R. McDonald at https://www.antagonism.org/privacy/gpg-vi.shtml
" Based on a solution by Wouter Hanegraaff
augroup encrypted
  au!

  " First make sure nothing is written to ~/.viminfo while editing
  " an encrypted file.
  autocmd BufReadPre,FileReadPre     *.gpg,*.asc set viminfo=
  " We don't want a swap file, as it writes unencrypted data to disk.
  autocmd BufReadPre,FileReadPre     *.gpg,*.asc set noswapfile
  " Switch to binary mode to read the encrypted file.
  autocmd BufReadPre,FileReadPre     *.gpg       set bin
  autocmd BufReadPre,FileReadPre     *.gpg,*.asc let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost   *.gpg,*.asc '[,']!sh -c 'gpg --decrypt 2> /dev/null'
  " Switch to normal mode for editing
  autocmd BufReadPost,FileReadPost   *.gpg       set nobin
  autocmd BufReadPost,FileReadPost   *.gpg,*.asc let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost   *.gpg,*.asc execute ":doautocmd BufReadPost " . expand("%:r")

  " Convert all text to encrypted text before writing
  autocmd BufWritePre,FileWritePre   *.gpg set bin
  autocmd BufWritePre,FileWritePre   *.gpg '[,']!sh -c 'gpg --default-recipient-self -e 2>/dev/null'
  autocmd BufWritePre,FileWritePre   *.asc '[,']!sh -c 'gpg --default-recipient-self -e -a 2>/dev/null'
  " Undo the encryption so we are back in the normal text, directly
  " after the file has been written.
  autocmd BufWritePost,FileWritePost *.gpg,*.asc u
augroup END
