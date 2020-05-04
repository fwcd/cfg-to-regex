defmodule CFGToRegex.CLI do
  alias CFGToRegex.G4Parser, as: G4Parser
  alias CFGToRegex.RegexGenerator, as: RegexGenerator

  @doc """
  Runs the compiler.

  The first argument is expected to be a file path pointing
  to an ANTLR grammar file.
  """
  def main(args) do
    [start_rule, path | _] = args
    raw = File.read!(path)
    {:ok, ast, _, _, _, _} = G4Parser.g4_grammar(raw)
    IO.inspect ast
    IO.puts RegexGenerator.from_ast(ast, start_rule)
  end
end
