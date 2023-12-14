" current root file: master.typ in current dir or main.typ in current dir
" else, search in parent dir
" else, current file
function! FindRoot()
  " current dir
  let l:root = expand('%:p:h')
  if filereadable(l:root.'/master.typ')
    return l:root
  elseif filereadable(l:root.'/main.typ')
    return l:root
  endif

  " parent dir
  let l:root = expand('%:p:h:h')
  if filereadable(l:root.'/master.typ')
    return l:root
  elseif filereadable(l:root.'/main.typ')
    return l:root
  endif
endfunction

inoremap <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.FindRoot().'/figures/"'<CR><CR>:w<CR>
nnoremap <C-f> : silent exec '!inkscape-figures edit "'.FindRoot().'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>

