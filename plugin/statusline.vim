" Black, White     Grey, DarkGrey  DarkRed          Red
" DarkBlue         Blue            DarkMagenta      Magenta
" DarkGreen        Green           DarkYellow       Yellow
" DarkCyan         Cyan

hi User1 ctermbg=DarkYellow ctermfg=Black guibg=DarkYellow guifg=Black
hi User2 ctermbg=DarkGray   ctermfg=Green guibg=DarkGray   guifg=SeaGreen cterm=bold term=bold
hi User3 ctermbg=DarkGray   ctermfg=White guibg=DarkGray   guifg=White
hi User4 ctermbg=Grey       ctermfg=Black guibg=Grey       guifg=Black
hi User5 ctermbg=Grey       ctermfg=Red   guibg=Grey       guifg=Red

"statusline setup
"set statusline=%f                   "tail of the filename
set statusline=                     "clear status line
"set statusline+=\"%{v:register}\          "active register
set statusline+=%1*%<               "Set color (and overflow behaviour) for window section
set statusline+=\ %n\               "buffer number
set statusline+=%{fugitive#statusline()}
set statusline+=%*                  "End color for window section
"set statusline+=%F\                 "full file name
set statusline+=%2*                 "Set color for filename section
set statusline+=\ %<%F              "relative path
set statusline+=%3*                 "Set color for file flags
set statusline+=%r                  "read only flag
set statusline+=%m                  "modified flag

"display a warning if &paste is set
set statusline+=%{&paste?'[paste]':''}
set statusline+=%2*                 "Set color for filename section

set statusline+=%=                  "left/right separator
set statusline+=%*                  "End file name section color
set statusline+=%4*                 "Set color for info section

set statusline+=%{StatuslineCurrentHighlight()}     " current highlight

set statusline+=%{StatuslineLongLineWarning()}      " lone lines

"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=--%{GitBranchInfoFindDir()}--

"Look for errors in loclist
set statusline+=%5*
set statusline+=%{Get_errors()}
set statusline+=%4*

"display a warning if &et is wrong, or we have mixed-indenting
"set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%{StatuslineTrailingSpaceWarning()}
"set statusline+=%*

set statusline+=%h                  "help file flag
set statusline+=%y                  "filetype

"display a warning if fileformat isnt unix and encoding isnt utf-8
set statusline+=[
set statusline+=%5*
set statusline+=%{RenderStlFlag(&ff,'unix',1)}
set statusline+=%4*
set statusline+=%{RenderStlFlag(&ff,'unix',0)}
set statusline+=,
set statusline+=%5*
set statusline+=%{RenderStlFlag(&fenc,'utf-8',1)}
set statusline+=%4*
set statusline+=%{RenderStlFlag(&fenc,'utf-8',0)}
set statusline+=]

set statusline+=[%{FileSize()}]     " Show file size

"set statusline+=%2*0x%04B\ %*          "character under cursor
set statusline+=%1*                 "Set color for nav section
set statusline+=%14(%c:%3l/%L%)     "cursor line/total lines
set statusline+=\ %P                "percent through file
set statusline+=%*                  "End nav section color
set laststatus=2

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")

        if !&modifiable
            let b:statusline_trailing_space_warning = ''
            return b:statusline_trailing_space_warning
        endif

        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let b:statusline_tab_warning = ''

        if !&modifiable
            return b:statusline_tab_warning
        endif

        let tabs = search('^\t', 'nw') != 0

        "find spaces that arent used as alignment in the first indent column
        let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")

        if !&modifiable
            let b:statusline_long_line_warning = ''
            return b:statusline_long_line_warning
        endif

        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

"returns a:value or ''
"
"a:goodValues is a comma separated string of values that shouldn't be
"highlighted with the error group
"
"a:error indicates whether the string that is returned will be highlighted as
"'error'
"
function! RenderStlFlag(value, goodValues, error)
  let goodValues = split(a:goodValues, ',')
  let good = index(goodValues, a:value) != -1
  if (a:error && !good) || (!a:error && good)
    return a:value
  else
    return ''
  endif
endfunction

function! FileSize()
    let bytes = getfsize(expand("%:p"))
    if bytes <= 0
        return ""
    endif
    if bytes < 1024
        return bytes
    else
        return (bytes / 1024) . "K"
    endif
endfunction

function! Get_errors()
    let l = getloclist(0)
    let errors = 0
    let warns = 0
    let error_line = ''
    let warn_line = ''
    for i in l
        if i.type == 'E'
            let errors += 1
            if errors == 1
                let error_line = ' (line: ' . i.lnum . ')'
            endif
        else
            let warns += 1
            if warns == 1
                let warn_line = ' (line: ' . i.lnum . ')'
            endif
        endif
    endfor

    let res = ''
    if errors > 0
        let res .= 'E: ' . errors . error_line . ' '
        "let res .= 'E: ' . errors
    endif
    if warns > 0
        "let res .= 'W: ' . warns . warn_line . ' '
        let res .= ' W: ' . warns
    endif
    if len(res) > 0
        return '[' . res . ']'
    else
        return ''
endfunction

" Set a satusline that gives some cool information.
"set statusline=%<%F%h%m%r%=\[%B\]\ %l,%c%V\ %P
"set statusline=%3*[%1*%02n%3*]%*\ %1*%F%*\ %2*%(%4*%m%2*%r%h%w%y%)%*\ %=%3*[%1*%{strftime(\"%Y-%m-%d\ %H:%M\")}%3*]%*\ %15(%3*<%1*%c%V,%l%3*/%1*%L%3*>%)%*
" We only want the statusline when we have more than one window.
"set laststatus=2 " or set to 2 to show always!
