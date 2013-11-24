" 
" jordify's .vimrc
" Last Modified: Wed Sep 04, 2013 at 20:08
"

runtime bundle/vim-pathogen/autoload/pathogen.vim

call pathogen#infect()
call pathogen#helptags()

" Main Options: {{{
set t_Co=256
colorscheme zenburn 

" use folding if we can
if has ('folding')
  set foldenable
  set foldmethod=marker
  set foldmarker={{{,}}}
  set foldcolumn=0
  set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo
endif

set autoindent
set autowrite
set backspace=indent,eol,start
set cursorline
set completeopt-=menu
set expandtab
set grepprg=grep\ -nH\ $*
set history=50
set hls
set incsearch
set laststatus=2
" Don't update the display while executing macros
set lazyredraw
set mouse=v
set nobackup
set nocompatible
set nomousehide
set nowrap
set novisualbell
set number
set ruler
set shiftwidth=2
set shortmess+=r
" Show me what mode I am in
set showmode
set showcmd
set showtabline=0
set smartindent
set smarttab
set splitright
set synmaxcol=2048
set title
set vb t_vb=
set wildmenu
set wildmode=list:longest,full

" syntax highlighting
syntax on
filetype plugin indent on

" some filetype stuff
let g:tex_flavor='latex'
let python_highlight_all = 1
let python_highlight_space_errors = 1
let python_fold=1
let lua_fold=1
let lua_version = 5
let lua_subversion = 1
" }}}

" KEYMAPS {{{
" faster esc in insert mode
inoremap kj <Esc>
inoremap <F1> <Esc>

" unmap annoying keys
nnoremap q: <Nop>
nnoremap q/ <Nop>
nnoremap q? <Nop>

" comment/uncomment a visual block
vmap ,c :call CommentLines()<CR>

" save the current file as root and reload
cmap w!! w !sudo tee % >/dev/null<CR>:e!<CR><CR>

" unmap the arrow keys
map <up> <nop>
map <left> <nop>
map <right> <nop>
map <down> <nop>
imap <up> <nop>
imap <left> <nop>
imap <right> <nop>
imap <down> <nop>

" }}}

" AUTOCOMMANDS {{{
if has('autocmd')
  " html
  au Filetype txt,html,xml,xsl set spell

  " update a Last Modified: line w/in the first 20 lines
  autocmd BufWritePre * call LastModified()

  " set the title string
  au BufEnter * let &titlestring = "vim: " . substitute(expand("%:p"), $HOME, "~", '')
  au BufEnter * let &titleold    = substitute(getcwd(), $HOME, "~", '')

  " set a better status line
  au BufRead * call SetStatusLine()

  " restore cursor position
  au BufReadPost * call RestoreCursorPos()
  au BufWinEnter * call OpenFoldOnRestore()

  " restore folds
  au BufWinEnter ?* silent! loadview
  au BufWinLeave ?* silent! mkview

  " file types for nonstandard/additional config files
  au BufNewFile,BufRead *conkyrc*          set ft=conkyrc
  au BufNewFile,BufRead *muttrc*           set ft=muttrc
  au BufNewFile,BufRead *.rem              set ft=remind
  au BufNewFile,BufRead $SCREEN_CONF_DIR/* set ft=screen
  au BufNewFile,BufRead *.xcolors          set ft=xdefaults
  au BufRead,BufNewFile /etc/nginx/*       set ft=nginx
  au BufRead,BufNewFile /srv/http/dokuwiki/data/pages/*       set ft=dokuwiki

  " change how vim behaves when composing emails
  au BufNewFile,BufRead ~/.mutt/temp/mutt* set ft=mail | set textwidth=72 | set spell | set nohls | source ~/.vim/autofix.vimrc

  au BufNewFile,BufRead ~/.mutt/temp/mutt* nmap  <F1>  gqap
  au BufNewFile,BufRead ~/.mutt/temp/mutt* nmap  <F2>  gqqj
  au BufNewFile,BufRead ~/.mutt/temp/mutt* nmap  <F3>  kgqj
  au BufNewFile,BufRead ~/.mutt/temp/mutt* map!  <F1>  <ESC>gqapi
  au BufNewFile,BufRead ~/.mutt/temp/mutt* map!  <F2>  <ESC>gqqji
  au BufNewFile,BufRead ~/.mutt/temp/mutt* map!  <F3>  <ESC>kgqji

  " set comment characters for common languages
  au FileType python,sh,bash,zsh,ruby,perl     let StartComment="#"  | let EndComment=""
  au FileType cpp,php,c,javascript             let StartComment="//" | let EndComment=""

  au FileType html    let StartComment="<!--" | let EndComment="-->"
  au FileType haskell let StartComment="--"   | let EndComment=""
  au FileType vim     let StartComment="\""   | let EndComment=""

  " file type specific commands
  au FileType c      set formatoptions+=ro
  au FileType make   set noexpandtab shiftwidth=8
  au FileType python set expandtab shiftwidth=2 tabstop=2
  au FileType vhdl   set expandtab shiftwidth=4 tabstop=4
  au FileType c      syn match matchName /\(#define\)\@<= .*/
  au FileType cpp    syn match matchName /\(#define\)\@<= .*/
  au FileType txt   setlocal textwidth=72
endif

" }}}

" FUNCTIONS {{{
function! LastModified()
  if &modified
    let save_cursor = getpos(".")
    let n = min([20, line("$")])
    exe '1,' . n . 's#^\(.\{,10}Last Modified: \).*#\1' .
              \ strftime('%a %b %d, %Y at %H:%M') . '#e'
    call setpos('.', save_cursor)
  endif
endfunction

function! SetStatusLine()
    let l:s1="%-3.3n\\ %f\\ %h%m%r%w"
    let l:s2="[%{strlen(&filetype)?&filetype:'?'},\\ %{&encoding},\\ %{&fileformat}]"
    let l:s3="%=\\ 0x%-8B\\ \\ %-14.(%l,%c%V%)\\ %<%P"
    execute "set statusline=" . l:s1 . l:s2 . l:s3
endfunction

function! RestoreCursorPos()
  if expand("<afile>:p:h") !=? $TEMP 
    if line("'\"") > 1 && line("'\"") <= line("$") 
      let line_num = line("'\"") 
      let b:doopenfold = 1 
      if (foldlevel(line_num) > foldlevel(line_num - 1)) 
        let line_num = line_num - 1 
        let b:doopenfold = 2 
      endif 
      execute line_num 
    endif 
  endif
endfunction

function! OpenFoldOnRestore()
  if exists("b:doopenfold") 
    execute "normal zv"
    if(b:doopenfold > 1)
      execute "+".1
    endif
    unlet b:doopenfold 
  endif
endfunction

function CommentLines()
  try
    execute ":s@^".g:StartComment." @\@g"
    execute ":s@ ".g:EndComment."$@@g"
  catch
    execute ":s@^@".g:StartComment." @g"
    execute ":s@$@ ".g:EndComment."@g"
  endtry
endfunction

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

function MapToggle(key, opt)
  let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
  exec 'nnoremap '.a:key.' '.cmd
  exec 'inoremap '.a:key." \<C-O>".cmd
endfunction

command -nargs=+ MapToggle call MapToggle(<f-args>)

MapToggle <F3> digraph 
MapToggle <F4> foldenable 
MapToggle <F5> number 
MapToggle <F6> spell 
MapToggle <F7> paste 
MapToggle <F8> hlsearch 
MapToggle <F9> wrap 

" }}}
