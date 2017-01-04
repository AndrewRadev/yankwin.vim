function! pastewin#Delete(params)
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

function! pastewin#Yank(params)
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

function! pastewin#Paste(params)
  let register = s:GetRegisterName()

  let edit_command = a:params.edit_command
  let [path, line, col] = s:PrePasteProcess(getreg(register))

  exe edit_command.' '.path
  if line != ''
    exe line
  endif
  if col != ''
    exe 'normal! 0'.col.'|'
  endif
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

function! s:PrePasteProcess(text)
  let path = a:text
  let line = ''
  let col = ''

  for [pattern, processor] in items(g:pastewin_paste_processors)
    let match = matchstr(path, pattern)

    if match != ''
      if has_key(processor, 'path')
        let path = substitute(match, pattern, processor.path, '')
      endif

      if has_key(processor, 'line')
        let line = substitute(match, pattern, processor.line, '')
      endif

      if has_key(processor, 'col')
        let col = substitute(match, pattern, processor.col, '')
      endif

      break
    endif
  endfor

  return [path, line, col]
endfunction
