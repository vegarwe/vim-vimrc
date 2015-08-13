" sensible.vim - Defaults everyone can agree on
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.1

if exists('g:loaded_sensible') || &compatible
  finish
else
  let g:loaded_sensible = 1
endif

if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" Use :help 'option' to see the documentation for the given option.

set autoindent
set backspace=indent,eol,start
"set complete-=i " Why not scan includes?
set smarttab

set nrformats-=octal

set timeout                 " allow keys to timeout
"set ttimeout
set ttimeoutlen=100
set  timeoutlen=100

""set smartindent             " (smartindent is deprecated)
set background=dark                 " gir ugly ugly farger, men men
"set clipboard+=unnamed      " put yanks/etc on the clipboard
"set errorbells              " beep/flash on errors, vil vi ha det da ???
set expandtab
"set foldmethod=marker
"set foldlevelstart=99       " start with all folds open
"set foldopen-=search        " don't open folds when you search into them
"set foldopen-=undo          " don't open folds when you undo stuff
"set hidden                  " lukker ikke ei fil i et buffer når du forlater den ('abandon')
set hlsearch                " highlighter siste søk, kjekt....
"set incsearch              " noen syntes dette er nice, jeg synes ikke det :P
set nowrap                  " vi liker da ikke wrap'ing... bare dritt
set number                  " for å få linjenumrering... litt slitsomt i starten
set nowarn
set suffixes+=.class,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,,
"set smartcase               " lurt når man driver å søker...
set shortmess+=at           " shortens messages to avoid 'press a key' prompt
set splitbelow
set splitright
set softtabstop=4
set shiftwidth=4            " two spaces per sw
set tabstop=4               " The One True Tab
"set textwidth=120          " set normal border; can unset for coding
set wildmode=longest,list,full   " (file-listing when opening a new file)
set mouse=v                  " mouse i visual mode, kan være kjekt
set cinkeys-=:
set formatoptions-=o       " See :help fo-table

set colorcolumn=+1

set laststatus=2
set ruler
set showcmd
"set showmatch               " Hopp kort til matchende block tegn ved avslutning )]}
set showmode                "show current mode down at the bottom
set wildmenu

if !&scrolloff
  set scrolloff=3
endif
if !&sidescrolloff
  set sidescrolloff=7
endif
set sidescroll=1
set display+=lastline

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

if &shell =~# 'fish$'
  set shell=/bin/bash
endif

set autoread
set fileformats+=mac

if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=256
  "set t_AB=<Esc>[48;5;%dm
  "set t_AF=<Esc>[38;5;%dm
endif
" litt usikker på denne også, men det kan se ut til at
" vi slipper disse tegnene (^[4%dm,^[3%dm) og det er bra
"if &term=="xterm"
"  set t_RV=          " don't check terminal version
"  set t_Co=8
"  set t_Sb=^[4%dm
"  set t_Sf=^[3%dm
"endif


" Highlight end of line white space
highlight WhitespaceEOL ctermbg=red guibg=red
"match WhitespaceEOL /\s\+$\| \+\ze\t/
:autocmd BufWinEnter * match WhitespaceEOL /\s\+$\| \+\ze\t/


" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

inoremap <C-U> <C-G>u<C-U>

" vim:set ft=vim et sw=2:
