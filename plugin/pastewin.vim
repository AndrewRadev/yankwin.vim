if exists('g:loaded_pastewin') || &cp
  finish
endif

let g:loaded_pastewin = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

if !exists('g:pastewin_default_mappings')
  let g:pastewin_default_mappings = 1
endif

if !exists('g:pastewin_only_allow_pasting_paths')
  let g:pastewin_only_allow_pasting_paths = 1
endif

if !exists('g:pastewin_paste_processors')
  let g:pastewin_paste_processors = {
        \ 'github\.com/\%(.\{-}\)/blob/\%([^/]\+\)/\(.\{-}\)\%(#L\(\d\+\)\%(-L\d\+\)\=\)\=$':
        \   {'path': '\1', 'line': '\2'},
        \ '^\(.\{-}\):\(\d\+\)\%(:\(\d\+\)\)\=':
        \   {'path': '\1', 'line': '\2', 'col': '\3'},
        \ }
endif

if !exists('g:pastewin_custom_paste_processors')
  let g:pastewin_custom_paste_processors = {}
endif

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
