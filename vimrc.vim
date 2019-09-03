" - INFO -
" Plugin folder for gvim on windows is 'vimfiles'
" and name of the rc file is '_vimrc'
"
" - DEFECTIVE PLUGINS ON WINDOWS -
" vim-gitgutter
" vim-indent-guides
"
" - CONFIGURATIONS -
" Execute pathogen plugins
execute pathogen#infect()

set nocompatible                " use vim settings rather then vi
"set term=xterm-256color

set showcmd                     "
set showmode                    " shows message at bottom when in insert, visual and replace modes
set number                      " show line numbers
set title                       " show file name in title
set autoindent                  " automatically indent lines to match previous line indention
set smartindent                 " smart indenting for code
set ignorecase                  " searches are case insensitive by default
set smartcase                   " unless uppercase letters where included
set mouse=a                     " enable mouse support
set ttymouse=xterm2
"set visualbell                  " Stop plinging, start blinking
set backspace=indent,eol,start  " allow backspace over everything in insert
set laststatus=2
set sw=4			" shiftwidth
set ts=4			" tabstop
set expandtab                   " convert tabs to spaces
set hlsearch 			" Highlight search
set ff=unix             " unix line endings
set re=1                " old regex engine is faster?

set whichwrap+=<,>,h,l,[,]      " wrap movement with these keys to next/prev line
                                " also makes delete in normal mode wrap aka delete lines

au BufNewFile,BufRead .vimlocal setlocal ft=vim
au BufRead,BufNewFile * set wrap linebreak nolist textwidth=0 wrapmargin=0

syntax on
set hidden
set ttyfast

" Set persistent undo
set undofile
set undodir=~/.vim/tempfiles
set undolevels=1000
set undoreload=10000

" remap escape sequence for home and end on mingw64 and windows ubuntu subsystem
map OH <home>
map OF <end>

" unmap recording and ex mode
:map q <NOP>
:map Q <NOP>

" Set vim temporary files to home folder
if !isdirectory($HOME."/.vim/tempfiles")
    call mkdir($HOME."/.vim/tempfiles", "p")
endif
set backupdir=~/.vim/tempfiles/
set directory=~/.vim/tempfiles/

" Rebind leader key
let mapleader=" "

" Rebind enter to colon
map <Enter> :

" Rebind gitgutter keys
map <Leader>< <Plug>GitGutterPrevHunk
map <Leader>> <Plug>GitGutterNextHunk

" colorscheme
let g:molokai_original = 0
colorscheme molokai
"hi MatchParen      ctermfg=208 ctermbg=233 cterm=bold
hi Visual term=reverse cterm=reverse guibg=Grey

" Add newlines with enter without going to insert mode
nmap <C-o> o<Esc>
" nmap <C-<CR>> o<Esc>

" Make a buffer file to home folder for copying between vims
vmap <C-y> "ny:new ~/.vimbuffer<CR>VG"nP:w<CR>:bdelete!<CR>:let @"=@0<CR>
vmap <C-d> "nd:new ~/.vimbuffer<CR>VG"nP:w<CR>:bdelete!<CR>:let @"=@0<CR>
nmap <C-y> :.w! ~/.vimbuffer<CR>
nmap <C-d> :.w! ~/.vimbuffer<CR>:let @n=@"<CR>dd:let @"=@n<CR>

" Paste from buffer
map <C-p> :r ~/.vimbuffer<CR>
imap <C-p> <C-o>:let pastemode = &paste<CR><C-o>:set paste<CR><CR><up><C-o>:r ~/.vimbuffer<CR><bs><end><del><C-o>:let &paste = pastemode<CR>
vmap <C-p> c<C-p><esc>

" Dont replace clipboard content when pasting over a selection
xnoremap p pgvy

" delete button does not replace default registry
nnoremap <del> "_x
vnoremap <del> "_x

" enter insert in paste mode and toggle between nopaste and paste while in insert
:map <F9> :set paste <CR><insert>
:imap <F9> <C-O>:set paste<CR>
:set pastetoggle=<F9>

" less help file
:map <F1> :!less ~/.vim_help<CR><CR>

" hide search highlight
:map <F3> :nohlsearch<CR>

" toggle line numbers
:map <F4> :call ToggleNumbers()<CR>

" Fix for gitgutter realtime processing error
set shell=/bin/bash

" Remove all trailing whitespace
nnoremap <Leader>t :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Disable modeline for its security issues
set nomodeline

" rotates line numbers; nonumbers -> numbers -> relativenumbers
function! ToggleNumbers()
    if &relativenumber == 1
        :GitGutterDisable
        set nonu
        set nornu
    elseif &number == 1
        set rnu
    else
        :GitGutterEnable
        set nu
    endif
endfunction


" Hotkey for resetting syntax highlighting
noremap <Leader>l <Esc>:syntax sync fromstart<CR>

" Settings for indent guides
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd ctermbg=237
hi IndentGuidesEven ctermbg=236


" Set folding to work by indentation
set foldmethod=indent
set foldlevelstart=20
hi Folded ctermbg=236
hi Folded ctermfg=75

" Stop # and * from going to the next element instantly
nmap <silent> * :let @/='\<'.expand('<cword>').'\>'<CR>
nmap <silent> # :let @/='\<'.expand('<cword>').'\>'<CR>

" Save current file as sudo if opened without sudo
cmap w!! w !sudo tee % > /dev/null

" Gitgutter settings
set updatetime=250
let g:gitgutter_max_signs = 600

" Adding splitting to vim
nnoremap <C-w>_ :vsplit<CR>
nnoremap <C-w>- :split<CR>

" Run file in interpreter
map <Leader>rh :! clear && haxe -main % --interp<CR>
map <Leader>rj :! clear && node %<CR>
map <Leader>rp :! clear && perl %<CR>


if has ('autocmd') " Remain compatible with earlier versions
 augroup vimrc     " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
endif " has autocmd

" autocmd vimenter * NERDTree

" Search for selected text.
" http://vim.wikia.com/wiki/VimTip171
let s:save_cpo = &cpo | set cpo&vim
if !exists('g:VeryLiteral')
  let g:VeryLiteral = 0
endif
function! s:VSetSearch(cmd)
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  normal! gvy
  if @@ =~? '^[0-9a-z,_]*$' || @@ =~? '^[0-9a-z ,_]*$' && g:VeryLiteral
    let @/ = @@
  else
    let pat = escape(@@, a:cmd.'\')
    if g:VeryLiteral
      let pat = substitute(pat, '\n', '\\n', 'g')
    else
      let pat = substitute(pat, '^\_s\+', '\\s\\+', '')
      let pat = substitute(pat, '\_s\+$', '\\s\\*', '')
      let pat = substitute(pat, '\_s\+', '\\_s\\+', 'g')
    endif
    let @/ = '\V'.pat
  endif
  normal! gV
  call setreg('"', old_reg, old_regtype)
endfunction
vnoremap <silent> * :<C-U>call <SID>VSetSearch('/')<CR>/<C-R>/<CR>
vnoremap <silent> # :<C-U>call <SID>VSetSearch('?')<CR>?<C-R>/<CR>
vmap <kMultiply> *
nmap <silent> <Plug>VLToggle :let g:VeryLiteral = !g:VeryLiteral
  \\| echo "VeryLiteral " . (g:VeryLiteral ? "On" : "Off")<CR>
if !hasmapto("<Plug>VLToggle")
  nmap <unique> <Leader>vl <Plug>VLToggle
endif
let &cpo = s:save_cpo | unlet s:save_cpo

" Make vim show full file path at the bottom
set statusline+=%F

" PC specific vim settings
source ~/.vimrc.local

