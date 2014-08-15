" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " For all text files set 'textwidth' to 78 characters.
  "autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  "autocmd filetype php set tabstop=4 shiftwidth=4 softtabstop=4
  "autocmd filetype html set tabstop=2 shiftwidth=2 softtabstop=2
  "autocmd filetype css set tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType php set omnifunc=phpcomplete#CompletePHP

  " associate *.tpl with php filetype
  "autocmd BufRead,BufNewFile *.tpl setfiletype xml
  "autocmd BufRead,BufNewFile *.tpl set syntax=xml

  "autocmd Syntax sql runtime! syntax/sql.vim

endif " has("autocmd")

" set tab width/behavior
set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab

" seek to matches as they are typed
set incsearch

" only care about case if case is mixed
set ignorecase smartcase

" search highlighting
set hlsearch
hi Search term=reverse cterm=NONE ctermfg=White ctermbg=Red gui=NONE guifg=White guibg=Red

" nullify the annoying VIM default behavior of ensuring every file ends in a 
" newline
" au BufWritePre * :set binary | set noeol
" au BufWritePost * :set nobinary | set eol

" colors
colo wombat256mod

" line numbers
set number

" search recursively up directory tree for tags file
set tags=tags;/

" open existing tab/window when switching buffers, otherwise open new tab
set switchbuf=usetab,useopen,newtab

" set tabline=%!MyTabLine()

" ----------------
" command mappings
" ----------------

" tab navigation
map <C-t>p :tabprevious<CR>
map <C-t>n :tabnext<CR>
map <C-t>c :tabnew<CR>

" clear search highlighting
map <F10> :nohls<CR>

" toggle code syntax highlighting
"map <F11> :if exists("syntax_on") <Bar>
"    \   syntax off <Bar> <CR>
"    \ else <Bar>
"    \   syntax enable <Bar>
"    \ endif <CR>

" toggle search highlighting
"map <F12> :set hls! hls?<CR>

" easy inclusion for logging backtrace
" docs:
"  http://vim-taglist.sourceforge.net/manual.html
"map <F2> <Esc>:TlistOpen<CR>
"map <F5> <Esc>:set paste<CR>o<CR>include_once '/home/kage/kage_dev/log_backtrace.php';<CR>log_backtrace();<CR><Esc>:set nopaste<CR>

" --------------
" plugin options
" --------------

" TagList
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
nnoremap <leader>l :!php -ln %<CR>
nnoremap <C-h> b
nnoremap <C-j> }
nnoremap <C-k> {
nnoremap <C-l> w

function! RunPHPUnitTest(filter)
	cd %:p:h
	if a:filter
		normal! T yw
		"normal! byw
		let result = system("phpunit --filter " . @" . " " . bufname("%"))
	else
		let result = system("phpunit " . bufname("%"))
	endif
	split __PHPUnit_Result__
	normal! ggdG
	setlocal buftype=nofile
	call append(0, split(result, '\v\n'))
	cd -
endfunction

function! GetClassMethods()
	cd %:p:h
	let result = system("~/utils/get_class_methods.sh " . bufname("%"))
	vsplit __ClassMethods__
	normal! ggdG
	setlocal buftype=nofile
	call append(0, split(result, '\v\n'))
	cd -
endfunction

nnoremap <leader>u :call RunPHPUnitTest(0)<cr>
" nnoremap <leader>f :call RunPHPUnitTest(1)<cr>
nnoremap <leader>m :call GetClassMethods()<cr>
nnoremap <leader>j :!jslint --unparam=true --nomen=true --es5=false --todo=true %<cr>
nnoremap <leader>p m`:%!js-beautify -f - -j<cr>``
nnoremap <leader>h m`:%!js-beautify --type html -f -<cr>``

execute pathogen#infect()
syntax on
filetype on
filetype plugin indent on

let g:ctrlp_match_files = 0
let g:ctrlp_clear_cache_on_exit = 0
command! W write
command! Wa wa

au FileType go nmap <Leader>r <Plug>(go-run)
au FileType go nmap <Leader>b <Plug>(go-build)
au FileType go nmap <Leader>t <Plug>(go-test)
au FileType go nmap gd <Plug>(go-def)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <leader>i <Plug>(go-install)


set tabstop=4
set shiftwidth=4
set expandtab

nnoremap <leader>z oif err != nil {<CR>fmt.Fprintln(os.Stderr, "", err)<CR>}<ESC>kt"la

au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,README.md  setf markdown

autocmd FileType markdown setlocal spell spelllang=en_us
