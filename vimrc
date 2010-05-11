" Aaron Stacy's .vimrc file

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" change "U" to redo
noremap U <C-R>

" get rid of audible bell
set vb 

" Change tab width
set softtabstop=4
set shiftwidth=2
set tabstop=2
set expandtab

" Press space to clear search highlighting and any message already displayed.
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>

" set tab to auto-complete and shift tab to omni-complete (intelligent, knows
" the default functions in certain languages)
inoremap <tab> <C-P>
"autocmd BufNewFile,BufRead *.php,*.html,*.css,*.js,*.sql,*.py,*.c inoremap <s-tab> <C-X><C-O>

" set F5 to insert date/time stamp in regular mode or insert mode
noremap <F5> "=strftime("%c")<CR>P
inoremap <F5> <C-R>=strftime("%c")<CR>

" for .note files, map shift-x to insert a new note
noremap <S-X> gg:insert<CR>================================================================<CR><Space><Space><Bar><Space><Space><C-R>=strftime("%c")<CR><Space><Space><Bar><Space><Space><CR>----------------------------------------------------------------<CR><CR>----------------------------------------------------------------<CR><CR><ESC><DEL>kkki

" set tabs to normal for Makefiles
au Filetype make set tabstop=4
au Filetype make inoremap <tab> <tab>
au Filetype make set paste
au Filetype make set noexpandtab

" set tabs to normal for text files
au Filetype text set tabstop=4
au Filetype text inoremap <tab> <tab>
au Filetype text set paste
au Filetype text set noexpandtab

" set tab width to 4 in python
au Filetype python set shiftwidth=4
au Filetype python set tabstop=4

" turn on the line number and location of the cursor as a percentage of the file
set ruler 

set history=50		" keep 50 lines of command line history
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set background=dark
set vb t_vb=

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif


" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Enable CTRL+aarow to switch between split windows
map <C-J> <C-W>j<C-W>_ 
map <C-K> <C-W>k<C-W>_ 

"" Set handy commenting feature
"" Perl, Python and shell scripts
"autocmd BufNewFile,BufRead *.py,*.pl,*.sh vmap u :-1/^#/s///<CR><Space>
"autocmd BufNewFile,BufRead *.py,*.pl,*.sh vmap c :-1/^/s//#/<CR><Space>
"" PHP
"autocmd BufNewFile,BufRead *.php vmap u :-1/^#/s///<CR><Space>
"autocmd BufNewFile,BufRead *.php vmap c :-1/^/s//#/<CR><Space>
"" Matlab
"autocmd BufNewFile,BufRead *.m,*.tex vmap u :-1/^%/s///<CR><Space>
"autocmd BufNewFile,BufRead *.m,*.tex vmap c :-1/^/s//%/<CR><Space>
"" Scheme
"autocmd BufNewFile,BufRead *.sc vmap u :-1/^;/s///<CR><Space>
"autocmd BufNewFile,BufRead *.sc vmap s :-1/^/s//;/<CR><Space>
"" C, C++
"autocmd BufNewFile,BufRead *.h,*.c,*.cpp vmap u :-1/^\/\//s///<CR><Space>
"autocmd BufNewFile,BufRead *.h,*.c,*.cpp vmap c :-1/^/s//\/\//<CR><Space>

" here's the new way to comment using NERD_commenter
vmap <space> ,c<space>
vmap c ,cl
vmap u ,cu

" the following allows the user to type :mksession in a directory,
" then when you return to the directory, all you have to do is open 
" vim and hit <F3> and vim will re-open all of your tabs
nmap <F3> <ESC>:call LoadSession()<CR>
let s:sessionloaded = 0
function LoadSession()
  source Session.vim
  let s:sessionloaded = 1
endfunction
function SaveSession()
  if s:sessionloaded == 1
    mksession!
  end
endfunction
autocmd VimLeave * call SaveSession()

let $PAGER=''

set mousemodel=extend

" handy if you crash w/ a bunch of open vim's, just recover the file and then
" type :DiffOrig
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
        \ | wincmd p | diffthis

" if the file starts w/ "#!" and "/bin/", automatically make it executable
au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent !chmod a+x <afile>

" Save file as 'sudo'
cmap w!! w !sudo tee % >/dev/null

"if has("python")
"  autocmd FileType html map ,b :python makeBold()
"  pyfile .vimpythonrc
"end

" some tips:
" increment/decrement a number: <c-a>/<c-x>
" capitalize: gU
"             so to toggle a character's case: ~
"             to capitalize a word: wgU
"             to lower-case a word: wgu
" to format a long line into an organized paragraph: gql
" to re-format windows newlines to *nix: :%s/<c-v><c-m>/\r\n/gc
" to do a command w/o exiting insert mode: <c-o>
" to pull a word into :ex mode (like for a search and replace): <c-r><c-w>
" show current file: <c-g>
" get the name of the current file :! echo %
" execute a command and paste the output into vim :r ! ls -la

