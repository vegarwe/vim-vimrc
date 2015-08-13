" Modda av meg sjæl våren 2004 - brukt alfborge's som samt gentoo's som grunnlag
" update Tue Jun  8 13:10:28 CEST 2004 --> lagt til F5 som nohlsearch
" $Id: .vimrc,v 1.9 2010/07/08 11:43:20 vegarwe Exp $

execute pathogen#infect()

let osys=system('uname -s')
let vimdir=$HOME . '/.vim/'
let &viminfo="'20," . '%,n' . vimdir . 'viminfo'
let &backupdir=vimdir . 'tmp'
set backup                  " Keep a backup file

if osys =~ "SunOS"
    set term=xtermc
    colorscheme desert
elseif osys =~ "Linux"
    colorscheme elflord
endif

" ========== <key bindings> ==============
let mapleader = "\<Enter>"
nnoremap <Leader>w :w<CR>
nnoremap <Leader>g :Git<Space>
nnoremap <silent> <Leader>cc :call g:ToggleSelectMode()<CR>
vmap    v  <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

nnoremap <xF1> <nop>
inoremap <xF1> <nop>
nnoremap <silent> <F2> :call g:ToggleSelectMode()<CR>
set pastetoggle=<F3>
nnoremap <silent> <F3> :set invpaste<CR>
nnoremap <silent> <F4> :set invnumber<CR>
nnoremap <F5> :ls<CR>:b
nnoremap <F7> :!MSBuild.exe build.xml /t:Local
nnoremap <F8> :!cygstart `find . -iname '*.uvproj'`

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
" ========== </key bindings> =============

" If we have a saved position in the file, go there.
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal g`\"" |
            \ endif

" Change directory to the directory of the file I'm working on.
"autocmd BufEnter *
"        \ if isdirectory( '%:p:h' ) |
"        \     lcd %:p:h |
"        \ endif

" Pr file type changes
"au BufNewFile,BufRead *py      set et sw=4

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

