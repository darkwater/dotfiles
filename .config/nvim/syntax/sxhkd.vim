if exists("b:current_syntax")
    finish
endif

syntax match sxhkdComment      /^#.*$/
syntax match sxhkdDescription  /^\w[^\t]*\ze\t/
syntax match sxhkdHotkey       /\t\zs[^\t]*\ze\t/
syntax match sxhkdCommand      /\t\zs[^\t]*$/

highlight link sxhkdComment      Comment
highlight link sxhkdDescription  Identifier
highlight link sxhkdHotkey       Function
highlight link sxhkdCommand      String

let b:current_syntax = "sxhkd"
