defmodule CFGToRegex.G4Parser do
  import NimbleParsec

  character = ascii_char([0..127])
  ident = ascii_string([?0..?9, ?a..?z, ?A..?Z], min: 1) |> tag(:ident)
  literal_quote = ascii_char [?']
  literal = literal_quote |> ascii_string([?0..?9, ?a..?z, ?A..?Z], min: 0) |> concat(literal_quote) |> tag(:literal)
  opt_whitespace = ascii_string [?\s, ?\n, ?\r, ?\t], min: 0
  req_whitespace = ascii_string [?\s, ?\n, ?\r, ?\t], min: 1
  newline_char = ascii_char [?\r, ?\n]
  newline = newline_char |> repeat(newline_char)

  single_line_comment = string("//") |> repeat(lookahead_not(newline) |> concat(character))
  multi_line_comment = string("/*") |> repeat(lookahead_not(string "*/") |> concat(character)) |> concat(string "*/")
  comment = choice [single_line_comment, multi_line_comment]
  opt_white = opt_whitespace
  req_white = choice [req_whitespace, comment]
  semi = ascii_char [?;]
  then_semi = concat(opt_white, semi)

  grammar_decl = string("grammar") |> concat(req_white) |> concat(ident) |> concat(then_semi) |> tag(:grammar_decl)
  rule_symbol = choice [ident, literal]
  rule_arm = rule_symbol |> repeat(concat(req_white, rule_symbol)) |> tag(:rule_arm)
  rule_rhs = rule_arm |> repeat(opt_white |> concat(string "|") |> concat(opt_white) |> concat(rule_arm))
  rule_decl = ident |> concat(opt_white) |> concat(string ":") |> concat(opt_white) |> concat(rule_rhs) |> concat(then_semi) |> tag(:rule_decl)

  defparsec :g4_grammar, opt_white |> concat(grammar_decl) |> concat(opt_white) |> concat(repeat(concat(opt_white, rule_decl))) |> concat(opt_white) |> concat(eos())
end
