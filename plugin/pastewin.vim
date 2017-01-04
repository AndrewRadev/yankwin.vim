if exists('g:loaded_pastewin') || &cp
  finish
endif

let g:loaded_pastewin = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

if !exists('g:pastewin_default_mappings')
  let g:pastewin_default_mappings = 1
endif

if !exists('g:pastewin_paste_processors')
  " TODO (2017-01-04) Real github url
  " TODO (2017-01-04) "Default" and "custom" processors

  let g:pastewin_paste_processors = {
        \ 'http://github.com/\(.\{-}\)\%(#L\(\d\+\)\)\=$': {'path': '\1', 'line': '\2'},
        \ '^\(.\{-}\):\(\d\+\)\%(:\(\d\+\)\)\=': {'path': '\1', 'line': '\2', 'col': '\3'},
        \ }
endif

" TODO (2016-12-23) Safeguards for "this doesn't look like a file?"
" TODO (2017-01-04) Custom formats for pasting (github urls)

if g:pastewin_default_mappings
  nnoremap <c-w>d  :call pastewin#Delete({'path_type': 'relative', 'with_line_number': 0})<cr>
  nnoremap <c-w>gd :call pastewin#Delete({'path_type': 'absolute', 'with_line_number': 0})<cr>
  nnoremap <c-w>D  :call pastewin#Delete({'path_type': 'relative', 'with_line_number': 1})<cr>
  nnoremap <c-w>gD :call pastewin#Delete({'path_type': 'absolute', 'with_line_number': 1})<cr>

  nnoremap <c-w>y  :call pastewin#Yank({'path_type': 'relative', 'with_line_number': 0})<cr>
  nnoremap <c-w>gy :call pastewin#Yank({'path_type': 'absolute', 'with_line_number': 0})<cr>
  nnoremap <c-w>Y  :call pastewin#Yank({'path_type': 'relative', 'with_line_number': 1})<cr>
  nnoremap <c-w>gY :call pastewin#Yank({'path_type': 'absolute', 'with_line_number': 1})<cr>

  nnoremap <c-w><c-p> :call pastewin#Paste({'edit_command': 'edit'})<cr>
  nnoremap <c-w>p     :call pastewin#Paste({'edit_command': 'leftabove split'})<cr>
  nnoremap <c-w>P     :call pastewin#Paste({'edit_command': 'rightbelow split'})<cr>
  nnoremap <c-w>gp    :call pastewin#Paste({'edit_command': '-tab split'})<cr>
  nnoremap <c-w>gP    :call pastewin#Paste({'edit_command': 'tab split'})<cr>
endif

let &cpo = s:keepcpo
unlet s:keepcpo
