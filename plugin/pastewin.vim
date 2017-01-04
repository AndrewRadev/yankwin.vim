if exists('g:loaded_pastewin') || &cp
  finish
endif

let g:loaded_pastewin = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

" TODO (2016-12-23) Safeguards for "this doesn't look like a file?"

nnoremap <c-w>d  :call pastewin#DeleteWindow({'path_type': 'relative', 'with_line_number': 0})<cr>
nnoremap <c-w>gd :call pastewin#DeleteWindow({'path_type': 'absolute', 'with_line_number': 0})<cr>
nnoremap <c-w>D  :call pastewin#DeleteWindow({'path_type': 'relative', 'with_line_number': 1})<cr>
nnoremap <c-w>gD :call pastewin#DeleteWindow({'path_type': 'absolute', 'with_line_number': 1})<cr>

nnoremap <c-w>y  :call pastewin#YankWindow({'path_type': 'relative', 'with_line_number': 0})<cr>
nnoremap <c-w>gy :call pastewin#YankWindow({'path_type': 'absolute', 'with_line_number': 0})<cr>
nnoremap <c-w>Y  :call pastewin#YankWindow({'path_type': 'relative', 'with_line_number': 1})<cr>
nnoremap <c-w>gY :call pastewin#YankWindow({'path_type': 'absolute', 'with_line_number': 1})<cr>

nnoremap <c-w><c-p> :call pastewin#PasteWindow({'edit_command': 'edit'})<cr>
nnoremap <c-w>p     :call pastewin#PasteWindow({'edit_command': 'leftabove split'})<cr>
nnoremap <c-w>P     :call pastewin#PasteWindow({'edit_command': 'rightbelow split'})<cr>
nnoremap <c-w>gp    :call pastewin#PasteWindow({'edit_command': '-tab split'})<cr>
nnoremap <c-w>gP    :call pastewin#PasteWindow({'edit_command': 'tab split'})<cr>


let &cpo = s:keepcpo
unlet s:keepcpo
