""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle
""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn off important incompatibilities with vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/

" This is the Vundle package, which can be found on GitHub.
" For GitHub repos, you specify plugins using the
" 'user/repository' format
call vundle#begin()
Plugin 'gmarik/vundle'
Plugin 'scrooloose/nerdtree.git'
Plugin 'Buffergator'
Plugin 'derekwyatt/vim-scala'
Plugin 'vimoutliner/vimoutliner'
Plugin 'tpope/vim-surround'
Plugin 'mattn/emmet-vim.git'
Plugin 'Glench/Vim-Jinja2-Syntax'
Plugin 'kien/rainbow_parentheses.vim' " Add matching parentheses
Plugin 'elzr/vim-json' " JSON support
Plugin 'bronson/vim-trailing-whitespace' " Trailing whitespace
Plugin 'tomasr/molokai' " Color theme; best background for vim
call vundle#end()

" Now we can turn our filetype functionality back on
filetype plugin indent on

"""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""
" Main Settings
"""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""
" Set column to light grey at 80 characters
if (exists('+colorcolumn'))
    set colorcolumn=80
    highlight ColorColumn ctermbg=9
endif

" Rainbow parentheses
try
	au VimEnter * RainbowParenthesesToggle
	au Syntax * RainbowParenthesesLoadRound
	au Syntax * RainbowParenthesesLoadSquare
	au Syntax * RainbowParenthesesLoadBraces
catch
endtry

" Tabs
map ;l :tabe . <ENTER>
map ;j :tabp <ENTER>
map ;k :tabn <ENTER>

" Set indentation settings
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4

" Enable movement within block of text
nnoremap k gk
nnoremap j gj
nnoremap 0 g0
nnoremap $ g$

" Autogenerate Parentheses, braces, and brackets
inoremap (<CR>  (<CR>)<Esc>O
inoremap (     (
inoremap ()     ()

inoremap {<CR>  {<CR>}<Esc>O
inoremap {     {
inoremap {}     {}

inoremap [<CR>  [<CR>]<Esc>O
inoremap [     [
inoremap []     []

nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-l> :wincmd l<CR>
nmap <silent> <C-h> :wincmd h<CR>

" Settings for writing
au BufNewFile,BufRead,BufEnter *.txt,*.md,*.markdown setlocal wrap
au BufNewFile,BufRead,BufEnter *.txt,*.md,*.markdown setlocal linebreak
au BufNewFile,BufRead,BufEnter *.txt,*.md,*.markdown setlocal spell spelllang=en_us
au BufRead,BufNewFile *.md set filetype=markdown
au BufRead,BufNewFile *.html set tabstop=2 shiftwidth=2
autocmd BufRead,BufNewFile *.tex setlocal wrap linebreak nolist textwidth=0 wrapmargin=0 formatoptions+=1 spell spelllang=en_us

" Additional syntax coloring options
au BufNewFile,BufRead *.hql set filetype=sql

" Settings for directory viewing (Scala-specific)
silent! nmap <C-p> :NERDTreeToggle<CR>
silent! map <F2> :NERDTreeToggle<CR>
silent! map <F3> :NERDTreeFind<CR>
let g:NERDTreeToggle="<F2>"
let g:NERDTreeMapActivateNode="<F3>"
let g:NERDTreeMapPreview="<F4>"
set wildignore+=*/target/*

" -- Solarized personal conf
try
	set t_Co=256 " says terminal has 256 colors
	let g:molokai_original = 1
	let g:rehash256 = 1
	colorscheme molokai
catch
endtry

" Remove trailing white space for certain files
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre *.otl,*.h,*.c,*.java,*.py,*.scala,*.sql,*.hql :call <SID>StripTrailingWhitespaces()
