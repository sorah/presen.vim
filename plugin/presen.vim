" presen.vim - presentation for vim

command! StartPresentation call s:Start()
command! ExitPresentation call s:Exit()

function! s:Start()


    let s:page_number = 0
    let s:max_page_number = 0
    let s:pages = []
    let s:using_presen_vim = 1

    setl readonly
    call s:ParseMarkdown()
    setl noreadonly

    tabe
    echo s:pages
    call s:ShowPage(1)

    command! -buffer PageNext call s:NextPage()
    command! -buffer PagePrev call s:PrevPage()

    nnoremap <buffer> <silent> <Space>n :PageNext<CR>
    nnoremap <buffer> <silent> <Space>p :PagePrev<CR>

endfunction

function! s:ShowPage(page_no)
    let s:page_number = a:page_no
    execute ":normal G$vggd"
    call append(1, s:pages[s:page_number])
endfunction

function! s:NextPage()
    if s:page_number+1 <= s:max_page_number
        let s:page_number += 1
        call s:ShowPage(s:page_number)
    endif
endfunction

function! s:PrevPage()
    if s:page_number-1 >= 0
        let s:page_number -= 1
        call s:ShowPage(s:page_number)
    endif
endfunction

function! s:Exit()
    delcommand PageNext
    delcommand PagePrev

    nunmap <Space>n
    nunmap <Space>p

    unlet s:page_number
    unlet s:max_page_number
    unlet s:pages
    unlet s:using_presen_vim

    bdelete

endfunction

function! s:ParseMarkdown()
    let l:lines = getline(1,line("$"))
    let l:pages_line = []
    echo "Parsing..."

    let i = 0
    while i < len(l:lines)
        echo l:lines[i]
        if l:lines[i] =~ "^#\+"
            echo "add"
            call add(l:pages_line,i)
        endif

        let i += 1
    endwhile

    let i = 0
    while i < len(l:pages_line)
        if i+1 < len(l:pages_line)
            let l:line = getline(l:pages_line[i]+1,l:pages_line[i+1])
        else
            let l:line = getline(l:pages_line[i]+1,line("$"))
        endif
        call add(s:pages,join(l:line,"\r\n"))

        let i += 1
    endwhile

    unlet i

    let s:max_page_number = len(s:pages)-1
    echo "Parse done"
endfunction

function! s:ParseMarkdown()
    let s:pages = split(join(getline(1, '$'), "\n"), '\v(^|\n)\ze#+')
    let s:max_page_number = len(s:pages) - 1
endfunction

