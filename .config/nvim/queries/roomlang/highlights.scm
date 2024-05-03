(Comment) @comment

(AssignmentPrefix (Identifier) @variable)
; (AssignmentPrefix (SpecialIdentifier) @keyword)

(Property (Identifier) @property)
; (Property (special_identifier) @property)

(Object (Identifier) @function)

(Literal_String) @string
(Number_Integer) @number
(Number_Float) @number.float
(Unit) @string

(RelativePosition_AtSide__at) @keyword
(RelativePosition_SideOffset__from) @keyword
(RelativePosition_ReferenceOffset__from) @keyword
(Cardinal) @keyword
(Direction) @keyword
(Edge__edge) @keyword
(SpecialReference) @keyword
(SpecialReference) @keyword

(Path) @variable

[
  (Dot)
  (Colon)
  (Equals)
  (Semicolon)
] @punctuation.delimiter

[
  (OpenBrace)
  (CloseBrace)
] @punctuation.bracket
