if exists('g:loaded_yankwin') || &cp
  finish
endif

let g:loaded_yankwin = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

if !exists('g:yankwin_default_mappings')
  let g:yankwin_default_mappings = 1
endif

if !exists('g:yankwin_default_delete_mappings')
  let g:yankwin_default_delete_mappings = 1
endif

if !exists('g:yankwin_default_yank_mappings')
  let g:yankwin_default_yank_mappings = 1
endif

if !exists('g:yankwin_default_paste_mappings')
  let g:yankwin_default_paste_mappings = 1
endif

if !exists('g:yankwin_only_allow_pasting_paths')
  let g:yankwin_only_allow_pasting_paths = 1
endif

if !exists('g:yankwin_yank_clipboard')
  let g:yankwin_yank_clipboard = ''
endif

if !exists('g:yankwin_paste_processors')
  let g:yankwin_paste_processors = {
        \ 'github\.com/\%(.\{-}\)/blob/\%([^/]\+\)/\(.\{-}\)\%(#L\(\d\+\)\%(-L\d\+\)\=\)\=$':
        \   {'path': '\1', 'line': '\2'},
        \ '^\(.\{-}\):\(\d\+\)\%(:\(\d\+\)\)\=':
        \   {'path': '\1', 'line': '\2', 'col': '\3'},
        \ }
endif

if !exists('g:yankwin_custom_paste_processors')
  let g:yankwin_custom_paste_processors = {}
endif

if g:yankwin_default_mappings
  if g:yankwin_default_delete_mappings
    nnoremap <c-w>d  :call yankwin#Delete({'path_type': 'relative', 'with_line_number': 0})<cr>
    nnoremap <c-w>gd :call yankwin#Delete({'path_type': 'absolute', 'with_line_number': 0})<cr>
    nnoremap <c-w>D  :call yankwin#Delete({'path_type': 'relative', 'with_line_number': 1})<cr>
    nnoremap <c-w>gD :call yankwin#Delete({'path_type': 'absolute', 'with_line_number': 1})<cr>

    tnoremap <c-w>d  <c-w>:call yankwin#Delete({'path_type': 'terminal'})<cr>
  endif

  if g:yankwin_default_yank_mappings
    nnoremap <c-w>y  :call yankwin#Yank({'path_type': 'relative', 'with_line_number': 0})<cr>
    nnoremap <c-w>gy :call yankwin#Yank({'path_type': 'absolute', 'with_line_number': 0})<cr>
    nnoremap <c-w>Y  :call yankwin#Yank({'path_type': 'relative', 'with_line_number': 1})<cr>
    nnoremap <c-w>gY :call yankwin#Yank({'path_type': 'absolute', 'with_line_number': 1})<cr>

    tnoremap <c-w>y  <c-w>:call yankwin#Yank({'path_type': 'terminal'})<cr>
  endif

  if g:yankwin_default_paste_mappings
    nnoremap <c-w><c-p> :call yankwin#Paste({'edit_command': 'edit'})<cr>
    nnoremap <c-w>p     :call yankwin#Paste({'edit_command': 'rightbelow split'})<cr>
    nnoremap <c-w>P     :call yankwin#Paste({'edit_command': 'leftabove split'})<cr>
    nnoremap <c-w>gp    :call yankwin#Paste({'edit_command': 'tab split'})<cr>
    nnoremap <c-w>gP    :call yankwin#Paste({'edit_command': (tabpagenr() - 1).'tab split'})<cr>

    tnoremap <c-w><c-p> <c-w>:call yankwin#Paste({'edit_command': 'edit'})<cr>
    tnoremap <c-w>p     <c-w>:call yankwin#Paste({'edit_command': 'rightbelow split'})<cr>
    tnoremap <c-w>P     <c-w>:call yankwin#Paste({'edit_command': 'leftabove split'})<cr>
    tnoremap <c-w>gp    <c-w>:call yankwin#Paste({'edit_command': 'tab split'})<cr>
    tnoremap <c-w>gP    <c-w>:call yankwin#Paste({'edit_command': (tabpagenr() - 1).'tab split'})<cr>
  endif
endif

let &cpo = s:keepcpo
unlet s:keepcpo
