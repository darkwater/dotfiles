" Tomorrow Night - Full Colour and 256 Colour
" http://chriskempson.com
"
" Hex colour conversion functions borrowed from the theme Desert256
" Edited version from Darkwater

set background=dark
hi clear
syntax reset

let g:colors_name = "tomorrow-night"

if has("gui_running") || &t_Co == 88 || &t_Co == 256

    " {{{ Helper functions

    " Returns an approximate grey index for the given grey level
    fun <SID>grey_number(x)
        if &t_Co == 88
            if a:x < 23
                return 0
            elseif a:x < 69
                return 1
            elseif a:x < 103
                return 2
            elseif a:x < 127
                return 3
            elseif a:x < 150
                return 4
            elseif a:x < 173
                return 5
            elseif a:x < 196
                return 6
            elseif a:x < 219
                return 7
            elseif a:x < 243
                return 8
            else
                return 9
            endif
        else
            if a:x < 14
                return 0
            else
                let l:n = (a:x - 8) / 10
                let l:m = (a:x - 8) % 10
                if l:m < 5
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " Returns the actual grey level represented by the grey index
    fun <SID>grey_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 46
            elseif a:n == 2
                return 92
            elseif a:n == 3
                return 115
            elseif a:n == 4
                return 139
            elseif a:n == 5
                return 162
            elseif a:n == 6
                return 185
            elseif a:n == 7
                return 208
            elseif a:n == 8
                return 231
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 8 + (a:n * 10)
            endif
        endif
    endfun

    " Returns the palette index for the given grey index
    fun <SID>grey_colour(n)
        if &t_Co == 88
            if a:n == 0
                return 16
            elseif a:n == 9
                return 79
            else
                return 79 + a:n
            endif
        else
            if a:n == 0
                return 16
            elseif a:n == 25
                return 231
            else
                return 231 + a:n
            endif
        endif
    endfun

    " Returns an approximate colour index for the given colour level
    fun <SID>rgb_number(x)
        if &t_Co == 88
            if a:x < 69
                return 0
            elseif a:x < 172
                return 1
            elseif a:x < 230
                return 2
            else
                return 3
            endif
        else
            if a:x < 75
                return 0
            else
                let l:n = (a:x - 55) / 40
                let l:m = (a:x - 55) % 40
                if l:m < 20
                    return l:n
                else
                    return l:n + 1
                endif
            endif
        endif
    endfun

    " Returns the actual colour level for the given colour index
    fun <SID>rgb_level(n)
        if &t_Co == 88
            if a:n == 0
                return 0
            elseif a:n == 1
                return 139
            elseif a:n == 2
                return 205
            else
                return 255
            endif
        else
            if a:n == 0
                return 0
            else
                return 55 + (a:n * 40)
            endif
        endif
    endfun

    " Returns the palette index for the given R/G/B colour indices
    fun <SID>rgb_colour(x, y, z)
        if &t_Co == 88
            return 16 + (a:x * 16) + (a:y * 4) + a:z
        else
            return 16 + (a:x * 36) + (a:y * 6) + a:z
        endif
    endfun

    " Returns the palette index to approximate the given R/G/B colour levels
    fun <SID>colour(r, g, b)
        " Get the closest grey
        let l:gx = <SID>grey_number(a:r)
        let l:gy = <SID>grey_number(a:g)
        let l:gz = <SID>grey_number(a:b)

        " Get the closest colour
        let l:x = <SID>rgb_number(a:r)
        let l:y = <SID>rgb_number(a:g)
        let l:z = <SID>rgb_number(a:b)

        if l:gx == l:gy && l:gy == l:gz
            " There are two possibilities
            let l:dgr = <SID>grey_level(l:gx) - a:r
            let l:dgg = <SID>grey_level(l:gy) - a:g
            let l:dgb = <SID>grey_level(l:gz) - a:b
            let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
            let l:dr = <SID>rgb_level(l:gx) - a:r
            let l:dg = <SID>rgb_level(l:gy) - a:g
            let l:db = <SID>rgb_level(l:gz) - a:b
            let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
            if l:dgrey < l:drgb
                " Use the grey
                return <SID>grey_colour(l:gx)
            else
                " Use the colour
                return <SID>rgb_colour(l:x, l:y, l:z)
            endif
        else
            " Only one possibility
            return <SID>rgb_colour(l:x, l:y, l:z)
        endif
    endfun

    " Returns the palette index to approximate the 'rrggbb' hex string
    fun <SID>rgb(rgb)
        let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
        let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
        let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

        return <SID>colour(l:r, l:g, l:b)
    endfun

    " Sets the highlighting for the given group
    fun <SID>X(group, fg, bg, attr)
        if a:fg != ""
            exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
        endif
        if a:bg != ""
            exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
        endif
        if a:attr != ""
            exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
        endif
    endfun

    " }}}


    " Colors used
    let s:black      = "000000"
    let s:shade00    = "1d1f21"
    let s:shade01    = "282a2e"
    let s:shade02    = "373b41"
    let s:shade03    = "969896"
    let s:shade04    = "b4b7b4"
    let s:shade05    = "c5c8c6"
    let s:shade06    = "e0e0e0"
    let s:shade07    = "ffffff"

    let s:red        = "cc6666"
    let s:orange     = "de935f"
    let s:yellow     = "f0c674"
    let s:green      = "b9ca4a" " Green is actually from Tomorrow Night Bright
    let s:cyan       = "8abeb7" "  because I don't like the TN green
    let s:blue       = "81a2be"
    let s:purple     = "b294bb"

    let s:darkred    = "551f21"
    let s:darkorange = "5e3f28"
    let s:darkyellow = "705d36"
    let s:darkgreen  = "314a21"
    let s:darkaqua   = "2d3e3c"
    let s:darkblue   = "2a353e"
    let s:darkpurple = "392f3b"

    let s:foreground = s:shade06
    let s:background = "none"
    let s:selection  = s:shade02
    let s:line       = s:shade01
    let s:comment    = s:shade03
    let s:accent     = "ffaf00"

    if has("gui_running")
        let s:background = s:shade00
    endif


    " Vim
    call <SID>X("Normal",        s:foreground,  s:background,  "none")
    call <SID>X("LineNr",        s:shade03,     "",            "none")
    call <SID>X("CursorLineNr",  s:accent,      s:line,        "none")
    call <SID>X("NonText",       s:selection,   "",            "none")
    call <SID>X("SpecialKey",    s:selection,   "",            "none")
    call <SID>X("Search",        s:accent,      s:black,       "none")
    call <SID>X("TabLine",       s:foreground,  s:background,  "none")
    call <SID>X("StatusLine",    s:shade07,     s:shade02,     "none")
    call <SID>X("StatusLineNC",  s:shade03,     s:shade02,     "none")
    call <SID>X("VertSplit",     s:shade02,     s:shade02,     "none")
    call <SID>X("Title",         s:comment,     "",            "")
    call <SID>X("Visual",        "",            s:selection,   "none")
    call <SID>X("Directory",     s:blue,        "",            "none")
    call <SID>X("ModeMsg",       s:green,       "",            "none")
    call <SID>X("MoreMsg",       s:green,       "",            "none")
    call <SID>X("Question",      s:green,       "",            "none")
    call <SID>X("WarningMsg",    s:red,         "",            "none")
    call <SID>X("MatchParen",    s:red,         s:black,       "none")
    call <SID>X("Folded",        s:comment,     s:background,  "none")
    call <SID>X("FoldColumn",    "",            s:background,  "none")
    call <SID>X("ErrorMsg",      s:red,         s:black,       "bold")
    if version >= 700
        call <SID>X("CursorLine",    "",            s:line,        "none")
        call <SID>X("CursorColumn",  "",            s:line,        "none")
        call <SID>X("PMenu",         s:foreground,  s:selection,   "none")
        call <SID>X("PMenuSel",      s:foreground,  s:selection,   "reverse")
        call <SID>X("SignColumn",    "",            s:background,  "none")
    end
    if version >= 703
        call <SID>X("ColorColumn",  "",  s:line,  "none")
    end

    " Custom TabLine
    call <SID>X("TabLineInactive",      s:shade02,  "",  "none")
    call <SID>X("TabLineInactiveBold",  s:shade03,  "",  "bold")
    call <SID>X("TabLineActive",        s:shade04,  "",  "none")
    call <SID>X("TabLineActiveBold",    s:shade07,  "",  "bold")
    call <SID>X("TabLineModified",      s:accent,   "",  "bold")

    " Standard
    call <SID>X("Comment",       s:comment,     "",         "italic")
    call <SID>X("Constant",      s:orange,      "",         "")
    call <SID>X("String",        s:green,       "",         "")
    call <SID>X("Character",     s:orange,      "",         "")
    call <SID>X("Number",        s:orange,      "",         "")
    call <SID>X("Boolean",       s:orange,      "",         "")
    call <SID>X("Float",         s:orange,      "",         "")
    call <SID>X("Identifier",    s:red,         "",         "")
    call <SID>X("Function",      s:blue,        "",         "")
    call <SID>X("Statement",     s:purple,      "",         "")
    call <SID>X("Conditional",   s:purple,      "",         "")
    call <SID>X("Repeat",        s:purple,      "",         "")
    call <SID>X("Label",         s:purple,      "",         "bold")
    call <SID>X("Operator",      s:cyan,        "",         "")
    call <SID>X("Keyword",       s:purple,      "",         "bold")
    call <SID>X("Exception",     s:purple,      "",         "")
    call <SID>X("PreProc",       s:cyan,        "",         "")
    call <SID>X("Include",       s:cyan,        "",         "")
    call <SID>X("Define",        s:cyan,        "",         "")
    call <SID>X("Macro",         s:cyan,        "",         "")
    call <SID>X("PreCondit",     s:cyan,        "",         "")
    call <SID>X("Todo",          s:comment,     s:shade02,  "")
    call <SID>X("Type",          s:blue,        "",         "")
    call <SID>X("StorageClass",  s:yellow,      "",         "")
    call <SID>X("Structure",     s:purple,      "",         "bold")
    call <SID>X("Typedef",       s:blue,        "",         "")
    call <SID>X("Special",       s:foreground,  "",         "")
    call <SID>X("Modifier",      s:purple,      "",         "none")

    " Vimlang
    call <SID>X("vimCommand",    s:blue,  "",  "none")
    call <SID>X("vimIsCommand",  s:blue,  "",  "none")

    " C
    call <SID>X("cType",          s:yellow,  "",  "")
    call <SID>X("cStorageClass",  s:purple,  "",  "")
    call <SID>X("cConditional",   s:purple,  "",  "")
    call <SID>X("cRepeat",        s:purple,  "",  "")

    " PHP
    call <SID>X("phpVarSelector",     s:red,         "",  "")
    call <SID>X("phpKeyword",         s:purple,      "",  "")
    call <SID>X("phpRepeat",          s:purple,      "",  "")
    call <SID>X("phpConditional",     s:purple,      "",  "")
    call <SID>X("phpStatement",       s:purple,      "",  "")
    call <SID>X("phpMemberSelector",  s:foreground,  "",  "")

    " Ruby
    call <SID>X("rubySymbol",                  s:green,   "",  "")
    call <SID>X("rubyConstant",                s:yellow,  "",  "")
    call <SID>X("rubyAttribute",               s:blue,    "",  "")
    call <SID>X("rubyInclude",                 s:blue,    "",  "")
    call <SID>X("rubyLocalVariableOrMethod",   s:orange,  "",  "")
    call <SID>X("rubyCurlyBlock",              s:orange,  "",  "")
    call <SID>X("rubyStringDelimiter",         s:green,   "",  "")
    call <SID>X("rubyInterpolationDelimiter",  s:orange,  "",  "")
    call <SID>X("rubyConditional",             s:purple,  "",  "")
    call <SID>X("rubyRepeat",                  s:purple,  "",  "")
    call <SID>X("rubyControl",                 s:purple,  "",  "")

    " Python
    call <SID>X("pythonInclude",      s:purple,  "",  "")
    call <SID>X("pythonStatement",    s:purple,  "",  "")
    call <SID>X("pythonConditional",  s:purple,  "",  "")
    call <SID>X("pythonRepeat",       s:purple,  "",  "")
    call <SID>X("pythonException",    s:purple,  "",  "")
    call <SID>X("pythonFunction",     s:blue,    "",  "")

    " Go
    call <SID>X("goStatement",    s:purple,  "",  "")
    call <SID>X("goConditional",  s:purple,  "",  "")
    call <SID>X("goRepeat",       s:purple,  "",  "")
    call <SID>X("goException",    s:purple,  "",  "")
    call <SID>X("goDeclaration",  s:blue,    "",  "")
    call <SID>X("goConstants",    s:yellow,  "",  "")
    call <SID>X("goBuiltins",     s:orange,  "",  "")

    " CoffeeScript
    call <SID>X("coffeeKeyword",      s:purple,  "",  "")
    call <SID>X("coffeeConditional",  s:purple,  "",  "")

    " JavaScript
    call <SID>X("javaScriptBraces",       s:foreground,  "",  "")
    call <SID>X("javaScriptFunction",     s:purple,      "",  "")
    call <SID>X("javaScriptConditional",  s:purple,      "",  "")
    call <SID>X("javaScriptRepeat",       s:purple,      "",  "")
    call <SID>X("javaScriptNumber",       s:orange,      "",  "")
    call <SID>X("javaScriptMember",       s:orange,      "",  "")

    " HTML
    call <SID>X("htmlTag",        s:red,  "",  "")
    call <SID>X("htmlTagName",    s:red,  "",  "")
    call <SID>X("htmlArg",        s:red,  "",  "")
    call <SID>X("htmlScriptTag",  s:red,  "",  "")

    " Diff
    let s:diffbackground = "494e56"
    call <SID>X("diffAdded",    s:green,           "",                "")
    call <SID>X("diffRemoved",  s:red,             "",                "")
    call <SID>X("DiffAdd",      s:green,           s:diffbackground,  "")
    call <SID>X("DiffDelete",   s:red,             s:diffbackground,  "")
    call <SID>X("DiffChange",   s:yellow,          s:diffbackground,  "")
    call <SID>X("DiffText",     s:diffbackground,  s:orange,          "")

    " NERDTree
    call <SID>X("NERDTreeHelp",      s:shade04,     "",  "")
    call <SID>X("NERDTreeUp",        s:shade05,     "",  "")
    call <SID>X("NERDTreeCWD",       s:blue,        "",  "bold")
    call <SID>X("NERDTreeDir",       s:blue,        "",  "")
    call <SID>X("NERDTreeDirSlash",  s:shade06,     "",  "")
    call <SID>X("NERDTreeFile",      s:foreground,  "",  "")
    call <SID>X("NERDTreeExecFile",  s:green,       "",  "bold")
    call <SID>X("NERDTreeLinkFile",  s:cyan,        "",  "bold")

    " GitGutter
    call <SID>X("GitGutterAdd",           s:darkgreen,   s:darkgreen,   "none")
    call <SID>X("GitGutterChange",        s:darkorange,  s:darkorange,  "none")
    call <SID>X("GitGutterChangeDelete",  s:red,         s:darkorange,  "underline")
    call <SID>X("GitGutterDelete",        s:red,         "",            "underline")

    " ShowMarks
    call <SID>X("ShowMarksHLl", s:orange, s:background, "none")
    call <SID>X("ShowMarksHLo", s:purple, s:background, "none")
    call <SID>X("ShowMarksHLu", s:yellow, s:background, "none")
    call <SID>X("ShowMarksHLm", s:cyan,   s:background, "none")

    " Delete Functions
    delf <SID>X
    delf <SID>rgb
    delf <SID>colour
    delf <SID>rgb_colour
    delf <SID>rgb_level
    delf <SID>rgb_number
    delf <SID>grey_colour
    delf <SID>grey_level
    delf <SID>grey_number
endif
