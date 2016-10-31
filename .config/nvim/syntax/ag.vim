if exists("b:current_syntax")
    finish
endif

" syntax match agEvent /\(^\t.*$\)\(\n^\t.*$\)*/ fold transparent
" syntax sync fromstart

syntax match agDate         /^\d\d-\d\d-\d\d/
syntax match agTime         /\<\d\d:\d\d\>/         containedin=agDescription
syntax match agDescription  /\t\zs.*$/          contains=agTime
syntax match agBody         /^\t\zs.*$/

highlight link agDate         Identifier
highlight link agTime         Constant
highlight link agDescription  Function
highlight link agBody         String

let b:current_syntax = "ag"
