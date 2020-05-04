defmodule CFGToRegex.G4Parser do
  import NimbleParsec

  character = ascii_char([0..127])
  ident = ascii_string([?0..?9, ?a..?z, ?A..?Z, ?_], min: 1) |> tag(:ident)
  literal_quote = ascii_char [?']
  literal = ascii_string([?0..?9, ?a..?z, ?A..?Z, ?\s, ?!, ?&, ?", ?., ?,, ?;, ?:, ?#, ?+, ?|, ?^, ?<, ?>, ?~, ?-, ?=, ?*, ?/, ?$, ?%, ?/, ?(, ?), ?[, ?], ?{, ?}, ??], min: 0) |> tag(:literal)
  quoted_literal = literal_quote |> concat(literal) |> concat(literal_quote)
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

  rule_symbol = choice [ident, quoted_literal]
  rule_arm = rule_symbol |> repeat(concat(req_white, rule_symbol)) |> tag(:rule_arm)
  rule_rhs = rule_arm |> repeat(opt_white |> concat(string "|") |> concat(opt_white) |> concat(rule_arm))
  rule_name = ident |> tag(:rule_name)
  rule_decl = rule_name |> concat(opt_white) |> concat(string ":") |> concat(opt_white) |> concat(rule_rhs) |> concat(then_semi) |> tag(:rule_decl)

  # Note that the fragment arm does not allow semicolons!
  fragment_arm = ascii_string([?0..?9, ?a..?z, ?A..?Z, ?\s, ?!, ?&, ?", ?., ?,, ?:, ?#, ?^, ?<, ?>, ?~, ?|, ?=, ?+, ?-, ?*, ?/, ?$, ?%, ?/, ?(, ?), ?[, ?], ?{, ?}, ??], min: 0) |> tag(:literal)
  fragment_rhs = fragment_arm |> repeat(opt_white |> concat(string "|") |> concat(opt_white) |> concat(fragment_arm))
  fragment_name = ident |> tag(:fragment_name)
  fragment_decl = string("fragment") |> concat(req_white) |> concat(fragment_name) |> concat(string ":") |> concat(opt_white) |> concat(fragment_rhs) |> concat(then_semi) |> tag(:fragment_decl)

  defparsec :g4_grammar, opt_white |> concat(grammar_decl) |> concat(opt_white) |> concat(repeat(opt_white |> choice([rule_decl, fragment_decl]))) |> concat(opt_white) |> concat(eos())
end
