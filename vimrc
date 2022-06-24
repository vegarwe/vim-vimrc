" Modda av meg sjæl våren 2004 - brukt alfborge's som samt gentoo's som grunnlag
" update Tue Jun  8 13:10:28 CEST 2004 --> lagt til F5 som nohlsearch
" $Id: .vimrc,v 1.9 2010/07/08 11:43:20 vegarwe Exp $

" Startup {{{
set nocompatible

let osys=system('uname -s')
let vimdir=$HOME . '/.vim/'
let &viminfo="'20," . '%,n' . vimdir . 'viminfo'
let &backupdir=vimdir . 'tmp'
set backup                  " Keep a backup file

" See README.md
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'jiangmiao/auto-pairs'
Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-rsi'        "Read line key bindings in command shell
"Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-fugitive'
"Plug 'leafgarland/typescript-vim'

"vim-statusline
call plug#end()


"if osys =~ "SunOS"
"    set term=xtermc
"    colorscheme desert
"elseif osys =~ "Linux"
"    colorscheme elflord
"endif
set termguicolors
colorscheme gruvbox

syntax on
filetype plugin indent on
" }}} Startup

" Set variables {{{
" Use :help 'option' to see the documentation for the given option.
set autoindent
""set smartindent             " (smartindent is deprecated)
set backspace=indent,eol,start
"set complete-=i " Why not scan includes?
set smarttab

set nrformats-=octal

set timeout                 " allow keys to timeout
"set ttimeout
set ttimeoutlen=100
set  timeoutlen=100

set background=dark         " gir ugly ugly farger, men men
set clipboard+=unnamed      " put yanks/etc on the clipboard
set noerrorbells            " beep/flash on errors, vil vi ha det da ??? Ehhh, nei takk
set novisualbell            " Ikke blink, for faen!
set expandtab
"set foldmethod=marker
"set foldlevelstart=99       " start with all folds open
"set foldopen-=search        " don't open folds when you search into them
"set foldopen-=undo          " don't open folds when you undo stuff
set hidden                  " lukker ikke ei fil i et buffer når du forlater den ('abandon')
set hlsearch                " highlighter siste søk, kjekt....
set noincsearch             " noen syntes dette er nice, jeg synes ikke det :P
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
" }}} Set variables

" Key bindings {{{
let mapleader = "\<Enter>"
nnoremap <Leader>w :w<CR>
nnoremap <Leader>g :Git<Space>
nnoremap <silent> <Leader>cc :call g:ToggleSelectMode()<CR>

vmap    v  <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

nnoremap <xF1> :NERDTreeToggle<CR>
inoremap <xF1> :NERDTreeToggle<CR>
nnoremap <silent> <F2> :call g:ToggleSelectMode()<CR>
set pastetoggle=<F3>
nnoremap <silent> <F3> :set invpaste<CR>
nnoremap <silent> <F4> :set invnumber<CR>
nnoremap <F5> :ls<CR>:b
"nnoremap <F7> :!MSBuild.exe build.xml /t:Local
"nnoremap <F8> :!cygstart `find . -iname '*.uvproj'`

inoremap <C-U> <C-G>u<C-U>

" split windows vertically, pleeeeease.
nnoremap <C-W><C-N> :vnew<CR>
nnoremap <C-W>n     :vnew<CR>

" Move easier between splits
"nnoremap <A-J> <C-W><C-J>
"nnoremap <A-K> <C-W><C-K>
"nnoremap <A-L> <C-W><C-L>
"nnoremap <A-H> <C-W><C-H>

" Navigate with space and backspace! Really nice
nmap <Space>        :tabnext<CR>
nmap <BackSpace>    :tabprevious<CR>

" Have typed q: instead of :q too many times to count
nnoremap q: :q

" Don't use Ex mode, use Q for formatting
map Q gq

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L>      :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

" Make it possible to select text with the mouse (for copying)
function! g:ToggleSelectMode()
  if &colorcolumn != ''
    setlocal colorcolumn&
    set wrap
    set nonumber
    execute 'sign unplace * buffer=' . bufnr('')
  else
    setlocal colorcolumn=100
    set nowrap
    set number
    execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
  endif
endfunction
" }}} Key bindings

" Terminal {{{
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
" }}} Terminal

" Buffer auto commands {{{
" Highlight end of line white space
highlight WhitespaceEOL ctermbg=red guibg=red
"match WhitespaceEOL /\s\+$\| \+\ze\t/
:autocmd BufWinEnter * match WhitespaceEOL /\s\+$\| \+\ze\t\|\t\+\ze /

" If we have a saved position in the file, go there.
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'svn\|commit\|gitcommit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

"spell check when writing commit logs
autocmd filetype svn,*commit* setlocal spell

" Change directory to the directory of the file I'm working on.
"autocmd BufEnter *
"        \ if isdirectory( '%:p:h' ) |
"        \     lcd %:p:h |
"        \ endif

" Pr file type changes
au BufNewFile,BufRead *py           set tw=120
au BufNewFile,BufRead *cpp,*java    set tw=120
au BufNewFile,BufRead *ts           set sw=2 ts=2
" }}} Buffer auto commands

" Plugins {{{
" ========== <Latex> ==============
" Autocompile tex files on write
" au BufRead,BufNewFile *.tex map :w<CR> :w<CR>:!pdflatex %<CR>

" latex-suite wants grep to always generate a file-name.
"set grepprg=grep\ -nH\ $*

"let g:Tex_DefaultTargetFormat="pdf"
" ========== </Latex> =============

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

" ========== <YouCompleteMe> ==============
"let g:ycm_confirm_extra_conf = 0
""let g:airline#extensions#loclist#enabled = 1
"let g:ycm_allow_changing_updatetime = 0
"set updatetime=200
"let g:ycm_always_populate_location_list = 1
"let g:ycm_auto_trigger = 0
"let g:EclimCompletionMethod = 'omnifunc'
"autocmd BufEnter * sign define dummy
"autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
" ========== </YouCompleteMe> =============

" ========== <Syntastic> ==============
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 0
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"autocmd BufEnter * sign define dummy
"autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
" ========== </Syntastic> =============

" ========== <NERDTree> ==============
let g:NERDTreeMouseMode = 2
let g:NERDTreeWinSize = 40
" ========== </NERDTree> =============

" ========== <CTRL-P> ================
let g:ctrlp_clear_cache_on_exit = 0
" ========== </CTRL-P> ===============


" ========== <CoC> ===================
" https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources#use-tab-or-custom-key-for-trigger-completion
" use <tab> for trigger completion and navigate to the next complete item
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~ '\s'
"endfunction
"
"inoremap <silent><expr> <Tab>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<Tab>" :
"      \ coc#refresh()
" ========== </CoC> ==================


" ========== <Mutt> ==============
"function! FormatMail()
"    " Fjern signatur
"    "if search('^> -- $', 'bw') != 0
"    "    .,/^-- $/d
"    "    exe "normal i
"-- 
""
"    "endif
"
"    " Fiks quoting
"    while search('^>\+[ \t]\+[>|]') != 0
"        %s/^\(>\+\)[ \t]*[>|]/\1>/g " Fjern spaces mellom quotetegn
"    endwhile
"    %s/\(^>\+\)\([^ \t>]\)/\1 \2/e    " Sett inn space mellom quotetegn og tekst
"
"    " Hopp til etter headerene
"    1
"    call search('^$')
"    redraw
"endfunction
"
"au BufRead mutt-* set et sw=2 ts=2
"au BufRead mutt-* call FormatMail()
"au BufNewFile,BufRead mutt*    set tw=77 ai nocindent fileencoding=utf-8
" ========== </Mutt> ==============
" }}} Plugins

if filereadable(".vimrc.custom")
    source .vimrc.custom
endif

" vim:fdm=marker
" zR to open all folds
