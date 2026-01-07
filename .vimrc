set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

set noeol

" set tab width/behavior - tabs always display as 8 spaces
set tabstop=8

" Enforce tabstop=8 after ftplugins load (they can override settings)
autocmd FileType * setlocal tabstop=8

" seek to matches as they are typed
set incsearch

" only care about case if case is mixed
set ignorecase smartcase

" search highlighting
set hlsearch
hi Search term=reverse cterm=NONE ctermfg=White ctermbg=Red gui=NONE guifg=White guibg=Red

" colors
colo wombat256mod

" line numbers
set nonumber

" search recursively up directory tree for tags file
set tags=tags;/

" open existing tab/window when switching buffers, otherwise open new tab
set switchbuf=usetab,useopen,newtab

" Show trailing whitepace and spaces before a tab:
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

" tab navigation
map <C-t>p :tabprevious<CR>
map <C-t>n :tabnext<CR>
map <C-t>c :tabnew<CR>
let Tlist_Exit_OnlyWindow = 1     " exit if taglist is last window open
let Tlist_Show_One_File = 1       " only show tags for current buffer
let Tlist_Enable_Fold_Column = 0  " no fold column (only showing one file)

" disable arrow keys to navigate for my newbishness
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

set gdefault
vnoremap <tab> %
nnoremap <tab> %

let mapleader= ","
nnoremap <leader><space> :noh<cr>
inoremap jj <ESC>

set nowrap

inoremap {<CR> {}<ESC>i<CR><ESC>ko
inoremap (<CR> ()<ESC>i<CR><ESC>ko
inoremap [<CR> []<ESC>i<CR><ESC>ko

au BufRead,BufNewFile *.XSD setfiletype xml
nnoremap <C-h> b
nnoremap <C-j> }
nnoremap <C-k> {
nnoremap <C-l> w

" Bootstrapping pathogen plugins and vim behavior
execute pathogen#infect()
syntax on
filetype on
filetype plugin indent on

" CtrlP configuration
let g:ctrlp_max_files = 0                " No file limit
let g:ctrlp_max_depth = 40               " Search deep
let g:ctrlp_clear_cache_on_exit = 0      " Persist cache
let g:ctrlp_show_hidden = 1              " Show hidden files
let g:ctrlp_working_path_mode = 'ra'     " Use nearest .git ancestor

" Use ripgrep for faster file listing (if available)
if executable('rg')
  let g:ctrlp_user_command = 'rg --files --no-ignore-vcs --hidden -g "!.git/" -g "!**/.venv/**" -g "!**/node_modules/**" -g "!**/__pycache__/**" -g "!*.pyc" %s'
  let g:ctrlp_use_caching = 0            " rg is fast enough
else
  " Fallback: ignore common large directories
  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](\.(git|hg|svn|venv)|node_modules|__pycache__|\.venv|venv|dist|build|vendor)$',
    \ 'file': '\v\.(exe|so|dll|pyc|pyo|class|o|a)$',
    \ }
endif

" Aliases for my fat fingers
command! W write
command! Wa wa

" Aliases and settings related to vim-go
au FileType go nmap <Leader>r <Plug>(go-run)
au FileType go nmap <Leader>b <Plug>(go-build)
au FileType go nmap <Leader>t <Plug>(go-test)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <leader>i <Plug>(go-install)
let g:go_fmt_command = "goimports"
let GOPATH = "~/go"

let g:rustfmt_autosave = 1

" Take care of Markdown file ending edge cases
au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,README.md  setf markdown

au BufNewFile,BufRead *.hcl  setf toml

" Spell check Markdown files
autocmd FileType markdown setlocal spell spelllang=en_us

" Set indentation behavior for JS/JSX (tabstop=8 for display, shiftwidth for indent)
autocmd FileType javascript setlocal shiftwidth=4 tabstop=8 softtabstop=4 expandtab smarttab
autocmd BufNewFile,BufRead *.jsx setlocal shiftwidth=4 tabstop=8 softtabstop=4 expandtab smarttab
autocmd BufNewFile,BufRead *.html setlocal shiftwidth=4 tabstop=8 softtabstop=4 expandtab smarttab
autocmd BufNewFile,BufRead *.tmpl setlocal shiftwidth=4 tabstop=8 softtabstop=4 expandtab smarttab
autocmd BufNewFile,BufRead *.scss setlocal shiftwidth=4 tabstop=8 softtabstop=4 expandtab smarttab
au BufNewFile,BufRead *.jsx set filetype=javascript.jsx
au BufNewFile,BufRead *.css set filetype=css
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab

" Wrap Markdown file to 80 char column
au BufRead,BufNewFile *.md setlocal textwidth=80
let g:hcl_fmt_autosave = 1
let g:tf_fmt_autosave = 1
let g:nomad_fmt_autosave = 1
let g:ale_fix_on_save = 1

set backspace=indent,eol,start

" map CTRL+\ in insert mode to (Plug)copilot-suggest
inoremap <C-\> <Plug>(copilot-suggest)

" map CTRL+] in insert mode to (Plug)copilot-next
inoremap <C-]> <Plug>(copilot-next)

nnoremap gd :ALEGoToDefinition<CR>


set pastetoggle=<F3>

function! AutoPaste()
  " Save the current register and clipboard settings
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  let old_clipboard = &clipboard

  " Set the clipboard to use the system clipboard
  set clipboard=unnamedplus

  " Toggle paste mode
  set paste

  " Paste the content from the clipboard
  normal! p

  " Toggle paste mode back
  set nopaste

  " Restore the register and clipboard settings
  call setreg('"', old_reg, old_regtype)
  let &clipboard = old_clipboard
endfunction

" Create a mapping for CTRL+C
inoremap <C-c> :call AutoPaste()<CR>

"let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

" ALE configuration
let g:ale_linters = {
\   'python': ['ruff', 'pyright'],
\   'go': ['gopls'],
\}
let g:ale_fixers = {
\   'python': ['ruff'],
\   'go': ['gofmt', 'goimports'],
\}
let g:ale_python_ruff_use_global = 1
let g:ale_python_pyright_use_global = 1
let g:ale_completion_enabled = 0
