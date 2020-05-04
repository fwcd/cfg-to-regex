defmodule CFGToRegex.G4Parser do
  import NimbleParsec

  # TODO: Match arbitrary characters as characters rather than binary
  character = ascii_char([0..127])
  ident = ascii_string([?0..?9, ?a..?z, ?A..?Z, ?_], min: 1) |> tag(:ident)
  literal_quote = ascii_char [?']
  literal = ascii_string([?0..?9, ?a..?z, ?A..?Z, ?\s, ?!, ?&, ?", ?., ?,, ?;, ?:, ?#, ?+, ?|, ?^, ?<, ?>, ?~, ?-, ?=, ?*, ?/, ?$, ?_, ?%, ?/, ?(, ?), ?[, ?], ?{, ?}, ??], min: 0) |> tag(:literal)
  quoted_literal = literal_quote |> concat(literal) |> concat(literal_quote)
  inline_regex = lookahead(ascii_char([?[, ?(])) |> ascii_string([?0..?9, ?a..?z, ?A..?Z, ?!, ?&, ?", ?., ?,, ?:, ?#, ?^, ?<, ?>, ?~, ?|, ?=, ?+, ?-, ?*, ?/, ?$, ?%, ?_, ?/, ?(, ?), ?[, ?], ?{, ?}, ??], min: 0) |> tag(:inline_regex)
  opt_whitespace = ascii_string [?\s, ?\n, ?\r, ?\t], min: 0
  req_whitespace = ascii_string [?\s, ?\n, ?\r, ?\t], min: 1
  newline_char = ascii_char [?\r, ?\n]
  newline = newline_char |> repeat(newline_char)

  # TODO: Fix comments
  single_line_comment = string("//") |> repeat(lookahead_not(newline) |> concat(character)) |> concat(newline)
  multi_line_comment = string("/*") |> repeat(lookahead_not(string "*/") |> concat(character)) |> concat(string "*/")
  comment = choice [single_line_comment, multi_line_comment]
  padded_comment = opt_whitespace |> concat(comment) |> concat(opt_whitespace)
  opt_white = choice [opt_whitespace, padded_comment]
  req_white = choice [req_whitespace, padded_comment]
  semi = ascii_char [?;]
  then_semi = concat(opt_white, semi)

  grammar_decl = string("grammar") |> concat(req_white) |> concat(ident) |> concat(then_semi) |> tag(:grammar_decl)

  rule_symbol = choice [ident, quoted_literal, inline_regex]
  rule_arm = rule_symbol |> repeat(concat(req_white, rule_symbol)) |> tag(:rule_arm)
  rule_rhs = rule_arm |> repeat(opt_white |> concat(string "|") |> concat(opt_white) |> concat(rule_arm))
  rule_name = ident |> tag(:rule_name)
  rule_decl = ignore(optional(string("fragment") |> concat(req_white))) |> concat(rule_name) |> concat(opt_white) |> concat(string ":") |> concat(opt_white) |> concat(rule_rhs) |> concat(then_semi) |> tag(:rule_decl)

  defparsec :g4_grammar, opt_white |> concat(grammar_decl) |> concat(opt_white) |> concat(repeat(opt_white |> concat(rule_decl))) |> concat(opt_white) |> concat(eos())
end
