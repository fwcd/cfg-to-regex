defmodule CFGToRegex.G4Parser do
  import NimbleParsec

  letter = ascii_char [?a..?z, ?A..?Z]
  digit = ascii_char [?0..?9]
  alphanumeric = choice [letter, digit]
  ident = letter |> repeat(choice [alphanumeric, ascii_char [?_]])
  whitespace_char = ascii_char [?\s, ?\n, ?\r, ?\t]
  opt_whitespace = repeat(whitespace_char)
  req_whitespace = whitespace_char |> repeat(whitespace_char)
  newline_char = ascii_char [?\r, ?\n]
  newline = newline_char |> repeat(newline_char)

  single_line_comment = string("//") |> eventually(newline)
  multi_line_comment = string("/*") |> eventually(string("*/"))
  comment = choice [single_line_comment, multi_line_comment]
  opt_white = opt_whitespace
  req_white = choice [req_whitespace, comment]
  semi = ascii_char [?;]
  then_semi = concat opt_white, semi

  grammar_decl = concat(concat(string("grammar"), req_white), concat(ident, then_semi))

  # TODO: Rule declarations

  defparsec :g4_grammar, grammar_decl
end
