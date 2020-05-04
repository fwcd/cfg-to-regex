defmodule CFGToRegex.RegexGenerator do
  defp from_rule_arm(arm) do
    arm |> Enum.flat_map(fn node -> case node do
      {:ident, ident} -> ["(?&#{ident})"]
      {:literal, literal} -> ["(?:#{literal})"]
      _ -> []
    end end) |> Enum.join("")
  end

  defp from_rule_decl(decl) do
    name = decl[:rule_name][:ident]
    alts = decl |> Enum.flat_map(fn node -> case node do
      {:rule_arm, arm} -> [from_rule_arm(arm)]
      _ -> []
    end end) |> Enum.join("|")
    "(?<#{name}>#{alts})"
  end

  @doc """
  Generates a (recursive) regex from the given G4 grammar AST.
  """
  def from_ast(ast) do
    ast |> Enum.flat_map(fn node -> case node do
      {:rule_decl, decl} -> [from_rule_decl(decl)]
      _ -> []
    end end) |> Enum.join("")
  end
end
