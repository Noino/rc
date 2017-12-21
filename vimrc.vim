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
hi MatchParen      ctermfg=208 ctermbg=233 cterm=bold 
hi Visual term=reverse cterm=reverse guibg=Grey

" Add newlines with enter without going to insert mode
nmap <C-o> o<Esc>
" nmap <C-<CR>> o<Esc>

" Make a buffer file to home folder for copying between vims
vmap <C-y> :w! ~/.vimbuffer<CR>
nmap <C-y> :.w! ~/.vimbuffer<CR>
" Paste from buffer
map <C-p> :r ~/.vimbuffer<CR>

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

" Make a breakpoint on underscores
set iskeyword-=_

if has ('autocmd') " Remain compatible with earlier versions
 augroup vimrc     " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
endif " has autocmd

" PC specific vim settings
source ~/.vimrc.local



