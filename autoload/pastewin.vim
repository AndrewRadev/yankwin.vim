function! pastewin#DeleteWindow(params)
  let path_type = a:params.path_type

  if expand('%') == ''
    quit
    return
  endif

  let register = s:GetRegisterName()
  let path_description = s:GetPathDescription(a:params)
  if path_description == ''
    return
  endif

  call setreg(register, path_description)
  if register == '"'
    call s:SynchronizeClipboards()
  endif

  echomsg 'Pastewin: Yanked "'.@@.'" to clipboard'
  quit
endfunction

function! pastewin#YankWindow(params)
  let path_type        = a:params.path_type
  let with_line_number = a:params.with_line_number

  let register = s:GetRegisterName()

  if expand('%') == ''
    echomsg "Pastewin: No buffer to yank"
    return
  endif

  let register = s:GetRegisterName()
  let path_description = s:GetPathDescription(a:params)
  if path_description == ''
    return
  endif

  call setreg(register, path_description)
  if register == '"'
    call s:SynchronizeClipboards()
  endif

  echomsg 'Pastewin: Yanked "'.@@.'" to clipboard'
endfunction

function! pastewin#PasteWindow(params)
  let register = s:GetRegisterName()

  let edit_command = a:params.edit_command
  exe edit_command.' '.getreg(register)
endfunction

function! s:GetRegisterName()
  if v:register == '+' || v:register == '*'
    " These should be synchronized upon reading, and we set them manually upon
    " writing, so just return the unnamed one
    return '"'
  else
    return v:register
  endif
endfunction

function! s:GetPathDescription(params)
  let path_type        = get(a:params, 'path_type', 'relative')
  let with_line_number = get(a:params, 'with_line_number', 0)

  if path_type == 'relative'
    let path_description = expand('%:~:.')
  elseif path_type == 'absolute'
    let path_description = expand('%:p')
  else
    echoerr "Pastewin: Unknown value for path_type: ".path_type
    return ''
  endif

  if with_line_number
    let path_description .= ':'.line('.')
  endif

  return path_description
endfunction

function! s:SynchronizeClipboards()
  let clipboard_setting = split(&clipboard)
  if index(clipboard_setting, 'unnamed') >= 0
    call setreg('*', @@)
  endif
  if index(clipboard_setting, 'unnamedplus') >= 0
    call setreg('+', @@)
  endif
endfunction
