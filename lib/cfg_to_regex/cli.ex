defmodule CFGToRegex.CLI do
  alias CFGToRegex.G4Parser, as: G4Parser
  alias CFGToRegex.RegexGenerator, as: RegexGenerator

  @doc """
  Runs the compiler.

  The first argument is expected to be a file path pointing
  to an ANTLR grammar file.
  """
  def main(args) do
    [path | _] = args
    raw = File.read!(path)
    {:ok, ast, _, _, _, _} = G4Parser.g4_grammar(raw)
    IO.puts RegexGenerator.from_ast(ast)
  end
end
