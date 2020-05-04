defmodule CFGToRegex.CLI do
  alias CFGToRegex.G4Parser, as: G4Parser

  @moduledoc """
  Documentation for `CFGToRegex.CLI`.
  """

  def main(args) do
    [path | _] = args
    raw = File.read!(path)
    ast = G4Parser.g4_grammar(raw)
    IO.inspect ast
  end
end
