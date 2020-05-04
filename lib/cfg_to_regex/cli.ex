defmodule CFGToRegex.CLI do
  alias CFGToRegex.G4Parser, as: G4Parser

  @moduledoc """
  Documentation for `CFGToRegex.CLI`.
  """

  def main(args) do
    [expr | _] = args
    ast = G4Parser.g4_grammar(expr)
    IO.inspect ast
  end
end
