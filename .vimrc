set nocompatible

filetype plugin indent on  " Load plugins according to detected filetype.
syntax on                  " Enable syntax highlighting.

set number

set autoindent             " Indent according to previous line.
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

set backspace   =indent,eol,start  " Make backspace work as you would expect.
set hidden                 " Switch between buffers without having to save first.
set laststatus  =2         " Always show statusline.
set display     =lastline  " Show as much as possible of the last line.

set showmode               " Show current mode in command-line.
set showcmd                " Show already typed keys when more are expected.

set incsearch              " Highlight while searching with / or ?.
set hlsearch               " Keep matches highlighted.

set ttyfast                " Faster redrawing.
set lazyredraw             " Only redraw when necessary.

set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

set cursorline             " Find the current line quickly.
set wrapscan               " Searches wrap around end-of-file.
set report      =0         " Always report changed lines.
set synmaxcol   =200       " Only highlight the first 200 columns.

set list                   " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" The fish shell is not very compatible to other shells and unexpectedly
" breaks things that use 'shell'.
if &shell =~# 'fish$'
  set shell=/bin/bash
endif

" Put all temporary files under the same directory.
" https://github.com/mhinz/vim-galore#temporary-files
set backup
set backupdir   =$HOME/.vim/files/backup/
set backupext   =-vimbackup
set backupskip  =
set directory   =$HOME/.vim/files/swap//
set updatecount =100
set undofile
set undodir     =$HOME/.vim/files/undo/
set viminfo     ='100,n$HOME/.vim/files/info/viminfo

call plug#begin('~/.vim/plugged')
    Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'tpope/vim-fugitive'
    Plug 'dense-analysis/ale'
call plug#end()

let mapleader=" "

let g:ctrlp_map = '<leader><leader>'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>t :CtrlPTag<cr>
nnoremap <leader>f :CtrlPBufTag<cr>
nnoremap <leader>q :CtrlPQuickfix<cr>
nnoremap <leader>m :CtrlPMRU<cr>

function! ToggleQuickFix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
endfunction

nnoremap <leader>w :call ToggleQuickFix()<cr>
nnoremap <leader>d :bd<cr>

nnoremap <leader>g :copen<cr>:Ggrep!<SPACE>
nnoremap K :Ggrep "\b<C-R><C-W>\b"<cr>:cw<cr>
nnoremap <leader>s :set hlsearch! hlsearch?<cr>

" ctags generation
nnoremap <leader>c :!ctags -R .<cr><cr>

set exrc
set secure

" Bind command and shortcut

command Stdheader call Baner#stdheader()
map <F1> :Stdheader<CR>
autocmd BufWritePre * Baner#update()


:autocmd BufNewFile, ej.c 0r ~/.vim/templates/skeleton.c

:autocmd BufNewFile *.c call Baner#stdheader()

:autocmd BufNewFile *.h call Baner#stdheader_h()


nnoremap <F2> :bp<cr>
nnoremap <F3> :bn<cr>

nnoremap <F9> :wall!<cr>:make!<cr><cr>

