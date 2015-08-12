" Modda av meg sjæl våren 2004 - brukt alfborge's som samt gentoo's som grunnlag
" update Tue Jun  8 13:10:28 CEST 2004 --> lagt til F5 som nohlsearch
" $Id: .vimrc,v 1.9 2010/07/08 11:43:20 vegarwe Exp $

"execute pathogen#infect()

" ========== <Vundle> ==============
set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
"Plugin 'tpope/vim-fugitive'
"Plugin 'tpope/vim-rsi.git'
Plugin 'vegarwe/vim-sensible'
Plugin 'Valloric/YouCompleteMe'
Plugin 'kien/ctrlp.vim'
Plugin 'terryma/vim-expand-region'
Plugin 'vegarwe/vim-statusline'
"Plugin 'bling/vim-airline'
"Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
"Plugin 'git://git.wincent.com/command-t.git'
call vundle#end()            " required
filetype plugin indent on    " required

" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" see :h vundle for more details or wiki for FAQ
" ========== </Vundle> ==============

let osys=system('uname -s')
let vimdir=$HOME . '/.vim/'
let &viminfo="'20," . '%,n' . vimdir . 'viminfo'
let &backupdir=vimdir . 'tmp'

if osys =~ "SunOS"
    set term=xtermc
    colorscheme desert
elseif osys =~ "Linux"
    colorscheme elflord
endif


"syntax on
"
"set nocompatible            " Use Vim defaults (much better!)
"set autoindent
""set smartindent             " Always set auto-indenting on (smartindent is deprecated)
""set bs=2                    " Allow backspacing over everything in insert mode
set colorcolumn=100
set bg=dark                 " gir ugly ugly farger, men men
set backup                  " Keep a backup file
"set backspace=indent,eol,start
"set clipboard+=unnamed      " put yanks/etc on the clipboard
"set errorbells              " beep/flash on errors, vil vi ha det da ???
"set novisualbell            " sørge for at vi bare får flash ihverfall
"set encoding=utf-8
set expandtab
"set foldmethod=marker
"set foldlevelstart=99       " start with all folds open
"set foldopen-=search        " don't open folds when you search into them
""set foldopen-=undo          " don't open folds when you undo stuff
"set history=1000            " keep 50 lines of command history
"set hidden                  " lukker ikke ei fil i et buffer når du forlater den ('abandon')
set hlsearch                " highlighter siste søk, kjekt....
""set incsearch              " noen syntes dette er nice, jeg synes ikke det :P
set nowrap                  " vi liker da ikke wrap'ing... bare dritt
set number                  " for å få linjenumrering... litt slitsomt i starten
set nowarn
"set ruler                   " Show the cursor position all the time
"set suffixes+=.class,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
"set showcmd
"set showmatch               " vise fold'a kode eller noe... ???
"set smartcase               " lurt når man driver å søker...
"set shortmess+=at           " shortens messages to avoid 'press a key' prompt
set shiftwidth=4            " two spaces per sw
set smarttab                " sw at start, not tab
set splitbelow
set splitright
set sts=4
set tabstop=4               " The One True Tab
""set textwidth=79           " set normal border; can unset for coding
"set timeout                 " allow keys to timeout
"set timeoutlen=3000         " timeout after 3s
""set viminfo='20,\"50       " read/write a .viminfo file -- limit to only 50
"set wildmode=list:longest   " (file-listing when opening a new file)
"set mouse=""                " OOOOOOOOOOOOOOOO, linjenummer blir ikke med når jeg higlighter!!!
"set cinkeys-=:
"set formatoptions+=ro       " See :help fo-table

" Set a satusline that gives some cool information.
"set statusline=%<%F%h%m%r%=\[%B\]\ %l,%c%V\ %P
"set statusline=%3*[%1*%02n%3*]%*\ %1*%F%*\ %2*%(%4*%m%2*%r%h%w%y%)%*\ %=%3*[%1*%{strftime(\"%Y-%m-%d\ %H:%M\")}%3*]%*\ %15(%3*<%1*%c%V,%l%3*/%1*%L%3*>%)%*
" We only want the statusline when we have more than one window.
"set laststatus=2 " or set to 2 to show always!

" ========== <key bindings> ==============
let mapleader = "\<Enter>"
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>g :!git<Space>
vmap    v  <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" adsf
nnoremap  <xF1> <nop>
inoremap  <xF1> <nop>
:nnoremap <silent> <F2> :call g:ToggleSelectMode()<CR>
set pastetoggle=<F3>
:nnoremap <silent> <F3> :set invpaste<CR>
:nnoremap <silent> <F4> :set invnumber<CR>
:nnoremap <F5> :ls<CR>:b
nnoremap  <F7> :!MSBuild.exe build.xml /t:Local
nnoremap  <F8> :!cygstart `find . -iname '*.uvproj'`

" split windows vertically, pleeeeease.
nnoremap <C-W><C-N> :vnew<CR>
nnoremap <C-W>n     :vnew<CR>

" Navigate with space and backspace! Really nice
nmap <Space>        :tabnext<CR>
nmap <BackSpace>    :tabprevious<CR>

" Have typed q: instead of :q too many times to count
nnoremap q: :q

" Don't use Ex mode, use Q for formatting
map Q gq
" ========== </key bindings> =============

" alfborge, hva gjør disse?
"nnoremap <silent> ,i i?<Esc>r
"nnoremap <silent> ,a a?<Esc>r

" If we have a saved position in the file, go there.
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal g`\"" |
            \ endif

" ========== <Latex> ==============
" Disable autoloading of vimspell
"let loaded_vimspell = 1
"let spell_insert_mode = 0
"let spell_auto_type = "tex,mail"
"let spell_language_list = "norsk,english"

" Autocompile tex files on write
" au BufRead,BufNewFile *.tex map :w<CR> :w<CR>:!pdflatex %<CR>

" latex-suite wants grep to always generate a file-name.
"set grepprg=grep\ -nH\ $*

"let g:Tex_DefaultTargetFormat="pdf"
" ========== </Latex> =============

" ========== <YouCompleteMe> ==============
let g:ycm_confirm_extra_conf = 0
"let g:airline#extensions#loclist#enabled = 1
let g:ycm_always_populate_location_list = 1
let g:ycm_auto_trigger = 0
autocmd BufEnter * sign define dummy
autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
" ========== </YouCompleteMe> =============

"" Change directory to the directory of the file I'm working on.
"autocmd BufEnter *
"        \ if isdirectory( '%:p:h' ) |
"        \     lcd %:p:h |
"        \ endif

" litt usikker på denne også, men det kan se ut til at
" vi slipper disse tegnene (^[4%dm,^[3%dm) og det er bra
if &term=="xterm"
  set t_RV=          " don't check terminal version
  set t_Co=8
  set t_Sb=^[4%dm
  set t_Sf=^[3%dm
endif

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
"au BufNewFile,BufRead *py      set et sw=4

" Make it possible to select text with the mouse (for copying)
function! g:ToggleSelectMode()
  if &colorcolumn != ''
    setlocal colorcolumn&
    set wrap
    set nonumber
  else
    setlocal colorcolumn=100
    set nowrap
    set number
  endif
endfunction
nnoremap <silent> <leader>cc :call g:ToggleSelectMode()<CR>

