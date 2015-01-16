syntax cluster BlockItem contains=BlockSequenceEntry,BlockMappingExplicitEntry,BlockMappingImplicitEntry

" {{{ Stream
syntax region Stream
    \ start=/\%^/
    \ end=/\%$/
    \ fold keepend
    \ contains=DirectivesDocument,ExplicitDocument,BareDocument
" }}}

" {{{ DirectivesDocument
syntax region DirectivesDocument
    \ start=/^%/
    \ end=/^\.\.\.\|^\(---\)\_.\{-}^\(---\)\@=/
    \ keepend
    \ contains=Directives,ExplicitDocument
    \ contained
" }}}

" {{{ Directives
syntax region Directives
    \ start=/^%/
    \ end=/^\.\.\.\|^\(---\)\@=/
    \ fold keepend
    \ contains=NONE
    \ contained
" }}}

" {{{ ExplicitDocument
syntax region ExplicitDocument
    \ start=/^---/
    \ end=/^\.\.\.\|^\(---\)\@=/
    \ fold keepend
    \ contains=BlockSequenceContent,BlockMappingContent
    \ contained
" }}}

" {{{ BareDocument
syntax region BareDocument
    \ start=/.\?/
    \ end=/^\.\.\.\|^\(---\)\@=/
    \ fold keepend
    \ contains=@BlockItem
    \ contained
" }}}

" {{{ BlockSequenceEntry
syntax region BlockSequenceEntry
    \ start=/^\z( *\)-\_[ ]/
    \ skip=/^\z1 \|^\%[\z1]$\|^\%[\z1]#.*$/
    \ end=/^/
    \ fold keepend
    \ contains=@BlockItem
    \ contained
" }}}

" {{{ BlockMappingExplicitEntry
syntax region BlockMappingExplicitEntry
    \ start=/^\z( *\)?\_[ ]\@=/
    \ skip=/^\z1[ :]\|^\%[\z1]$\|^\%[\z1]#.*$/
    \ end=/^/
    \ fold keepend
    \ contains=@BlockItem
    \ contained
" }}}

" {{{ BlockMappingImplicitEntry
syntax region BlockMappingImplicitEntry
    \ start=/^\z( *\)\([^ ?-]\|-[^ \n]\)[^#]*:\_[ ]\@=/
    \ skip=/^\z1[ -]\|^\%[\z1]$\|^\%[\z1]#.*$/
    \ end=/^/
    \ fold keepend
    \ contains=@BlockItem
    \ contained
" }}}

" vim: fdm=marker expandtab
