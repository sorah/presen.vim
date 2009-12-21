" presen.vim - presentation for vim

command! StartPresentation call s:Start()
command! ExitPresentation call s:Exit()

function! s:Start()
    command! -buffer PageNext call s:Next()
    command! -buffer PagePrev call s:Prev()

    nnoremap <buffer> <silent> <Space>n :PageNext
    nnoremap <buffer> <silent> <Space>p :PagePrev

    let s:page_number = 0
endfunction

function! s:Exit()
    delcommand PageNext
    delcommand PagePrev

    nunmap <Space>n
    nunmap <Space>p
endfunction


