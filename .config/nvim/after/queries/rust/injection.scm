; extends

; sqlx macro highlighting
(macro_invocation
  macro: [
    (scoped_identifier
      name: (_) @_macro_name)
    (identifier) @_macro_name
  ]
  (token_tree
    (raw_string_literal
      (string_content) @injection.content))
  (#match? @_macro_name "query(_as|_scalar|)")
  (#set! injection.language "sql"))
