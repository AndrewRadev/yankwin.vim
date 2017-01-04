if exists('g:loaded_pastewin') || &cp
  finish
endif

let g:loaded_pastewin = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

" TODO (2016-12-23) Different registers
" TODO (2016-12-23) Safeguards for "this doesn't look like a file?"

nnoremap <c-w>d  :call <SID>DeleteWindow({'path_type': 'relative'})<cr>
nnoremap <c-w>gd :call <SID>DeleteWindow({'path_type': 'absolute'})<cr>

nnoremap <c-w>y  :call <SID>YankWindow({'path_type': 'relative', 'with_line_number': 0})<cr>
nnoremap <c-w>gy :call <SID>YankWindow({'path_type': 'absolute', 'with_line_number': 0})<cr>
nnoremap <c-w>Y  :call <SID>YankWindow({'path_type': 'relative', 'with_line_number': 1})<cr>
nnoremap <c-w>gY :call <SID>YankWindow({'path_type': 'absolute', 'with_line_number': 1})<cr>

nnoremap <c-w><c-p> :call <SID>PasteWindow({'edit_command': 'edit'})<cr>
nnoremap <c-w>p     :call <SID>PasteWindow({'edit_command': 'leftabove split'})<cr>
nnoremap <c-w>P     :call <SID>PasteWindow({'edit_command': 'rightbelow split'})<cr>
nnoremap <c-w>gp    :call <SID>PasteWindow({'edit_command': '-tab split'})<cr>
nnoremap <c-w>gP    :call <SID>PasteWindow({'edit_command': 'tab split'})<cr>

function! s:DeleteWindow(params)
  let path_type = a:params.path_type

  let register = v:register
  if register == '+' || register == '*'
    " We set those registers manually
    let register = '"'
  endif

  if expand('%') == ''
    return
  endif

  if path_type == 'relative'
    let path = expand('%:~:.')
  elseif path_type == 'absolute'
    let path = expand('%:p')
  else
    echoerr "Pastewin: Unknown value for path_type: ".path_type
    return
  endif

  call setreg(register, path)

  let clipboard_setting = split(&clipboard)
  if register == '"' && index(clipboard_setting, 'unnamed') >= 0
    call setreg('*', @@)
  endif
  if register == '"' && index(clipboard_setting, 'unnamedplus') >= 0
    call setreg('+', @@)
  endif

  echomsg 'Pastewin: Yanked "'.@@.'" to clipboard'
  quit
endfunction

function! s:YankWindow(params)
  let path_type        = a:params.path_type
  let with_line_number = a:params.with_line_number

  let register = v:register
  if register == '+' || register == '*'
    " We set those registers manually
    let register = '"'
  endif

  if expand('%') == ''
    echomsg "Pastewin: No buffer to yank"
    return
  endif

  if path_type == 'relative'
    let path = expand('%:~:.')
  elseif path_type == 'absolute'
    let path = expand('%:p')
  else
    echoerr "Pastewin: Unknown value for path_type: ".path_type
    return
  endif

  if with_line_number
    let @@ = path.':'.line('.')
    call setreg(register, path.':'.line('.'))
  else
    call setreg(register, path)
  endif

  let clipboard_setting = split(&clipboard)
  if register == '"' && index(clipboard_setting, 'unnamed') >= 0
    call setreg('*', @@)
  endif
  if register == '"' && index(clipboard_setting, 'unnamedplus') >= 0
    call setreg('+', @@)
  endif

  let clipboard_setting = split(&clipboard, ',')

  if index(clipboard_setting, 'unnamed') >= 0
    let @* = @@
  endif

  if index(clipboard_setting, 'unnamedplus') >= 0
    let @+ = @@
  endif

  echomsg 'Pastewin: Yanked "'.@@.'" to clipboard'
endfunction

function! s:PasteWindow(params)
  let register = v:register
  if register == '+' || register == '*'
    " Those should be synchronized
    let register = '"'
  endif

  let edit_command = a:params.edit_command
  exe edit_command.' '.getreg(register)
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
