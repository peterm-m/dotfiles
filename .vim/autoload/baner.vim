let s:asciiart = [
      \'        :::      ::::::::',
      \'      :+:      :+:    :+:',
      \'    +:+ +:+         +:+  ',
      \'  +#+  +:+       +#+     ',
      \'+#+#+#+#+#+   +#+        ',
      \'     #+#    #+#          ',
      \'    ###   ########.fr    '
      \]

let s:start   = '/*'
let s:end   = '*/'
let s:fill    = '*'
let s:length  = 80
let s:margin  = 5

let s:types   = {
      \'\.c$\|\.h$\|\.cc$\|\.hh$\|\.cpp$\|\.hpp$\|\.php':
      \['/*', '*/', '*'],
      \'\.htm$\|\.html$\|\.xml$':
      \['<!--', '-->', '*'],
      \'\.js$':
      \['//', '//', '*'],
      \'\.tex$':
      \['%', '%', '*'],
      \'\.ml$\|\.mli$\|\.mll$\|\.mly$':
      \['(*', '*)', '*'],
      \'\.vim$\|\vimrc$':
      \['"', '"', '*'],
      \'\.el$\|\emacs$':
      \[';', ';', '*'],
      \'\.f90$\|\.f95$\|\.f03$\|\.f$\|\.for$':
      \['!', '!', '/']
      \}

function! s:date()
  return strftime("%Y/%m/%d %H:%M:%S")
endfunction

function! s:insert_c()
  let l:line = 11

    call append(0, "")
  " loop over lines
  while l:line > 0
    call append(0, s:line(l:line))
    let l:line = l:line - 1
  endwhile
endfunction

function! s:filetype()
  let l:f = s:filename()

  let s:start = '#'
  let s:end = '#'
  let s:fill  = '*'

  for type in keys(s:types)
    if l:f =~ type
      let s:start = s:types[type][0]
      let s:end = s:types[type][1]
      let s:fill  = s:types[type][2]
    endif
  endfor

endfunction

function! s:ascii(n)
  return s:asciiart[a:n - 3]
endfunction

function! s:textline(left, right)
  let l:left = strpart(a:left, 0, s:length - s:margin * 2 - strlen(a:right))

  return s:start . repeat(' ', s:margin - strlen(s:start)) . l:left . repeat(' ', s:length - s:margin * 2 - strlen(l:left) - strlen(a:right)) . a:right . repeat(' ', s:margin - strlen(s:end)) . s:end
endfunction

function! s:filename()
  let l:filename = expand("%:t")
  if strlen(l:filename) == 0
    let l:filename = "< new >"
  endif
  return l:filename
endfunction

function! s:line(n)
  if a:n == 1 || a:n == 11 " top and bottom line
    return s:start . ' ' . repeat(s:fill, s:length - strlen(s:start) - strlen(s:end) - 2) . ' ' . s:end
  elseif a:n == 2 || a:n == 10 " blank line
    return s:textline('', '')
  elseif a:n == 3 || a:n == 5 || a:n == 7 " empty with ascii
    return s:textline('', s:ascii(a:n))
  elseif a:n == 4 " filename
    return s:textline(s:filename(), s:ascii(a:n))
  elseif a:n == 6 " author
    return s:textline("By: pedromar <pedromar@student.42madrid.com>", s:ascii(a:n))
  elseif a:n == 8 " created
    return s:textline("Created: " . s:date() . " by pedromar", s:ascii(a:n))
  elseif a:n == 9 " updated
    return s:textline("Updated: " . s:date() . " by pedromar", s:ascii(a:n))
  endif
endfunction

"
"
" for files h
"
"

function! s:guard_name()
  let l:guard_name = toupper(substitute(expand("%:t"), '\.', '_', ''))
  if strlen(l:guard_name) == 0
    let l:guard_name = "< new >"
  endif
  return l:guard_name
endfunction


function! s:line_guard(n)
  if a:n == 1 || a:n == 11" top and bottom line
    return s:start . ' ' . repeat(s:fill, s:length - strlen(s:start) - strlen(s:end) - 2) . ' ' . s:end
  elseif a:n == 2 || a:n == 10 " blank line
    return s:textline('', '')
  elseif a:n == 3 || a:n == 5 || a:n == 7 " empty with ascii
    return s:textline('', s:ascii(a:n))
  elseif a:n == 4 " filename
    return s:textline(s:filename(), s:ascii(a:n))
  elseif a:n == 6 " author
    return s:textline("By: pedromar <pedromar@student.42madrid.com>", s:ascii(a:n))
  elseif a:n == 8 " created
    return s:textline("Created: " . s:date() . " by pedromar", s:ascii(a:n))
  elseif a:n == 9 " updated
    return s:textline("Updated: " . s:date() . " by pedromar", s:ascii(a:n))
  elseif a:n == 12
    return ''
  elseif a:n == 13
    return "#ifndef " . s:guard_name()
  elseif a:n == 14
    return "# define " . s:guard_name()
  elseif a:n == 15
    return ''
  elseif a:n == 16
    return '#endif'
  endif
endfunction

function! s:insert_header()
  let l:line = 16

  " loop over lines
  while l:line > 0
    call append(0, s:line_guard(l:line))
    let l:line = l:line - 1
  endwhile
endfunction

function! Baner#update()
  call s:filetype()
  if getline(9) =~ s:start . repeat(' ', s:margin - strlen(s:start)) . "Updated: "
    if &mod
      call setline(9, s:line(9))
    endif
    call setline(4, s:line(4))
    return 0
  endif
  return 1
endfunction

function! Baner#update_header()
  call s:filetype()
  if getline(9) =~ s:start . repeat(' ', s:margin - strlen(s:start)) . "Updated: "
    if &mod
      call setline(9, s:line(9))
    endif
    call setline(4, s:line_guar(4))
    call setline(13, s:line_guar(13))
    call setline(14, s:line_guar(14))
    return 0
  endif
  return 1
endfunction

function! Baner#stdheader_h()
  if Baner#update_header()
      call s:insert_header()
      17delete
      15
  endif
endfunction

function! Baner#stdheader_c()
  if Baner#update()
    call s:insert_c()
	21delete
	18
  endif
endfunction
