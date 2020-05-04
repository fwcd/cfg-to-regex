defmodule CFGToRegex.RegexGenerator do
  defp as_arm(node) do
    case node do
      {:rule_arm, arm} -> arm
      _ -> nil
    end
  end

  defp as_decl(node) do
    case node do
      {:rule_decl, decl} -> decl
      _ -> nil
    end
  end

  defp decls(ast) do
    ast |> Enum.map(&as_decl/1)
        |> Enum.reject(&is_nil/1)
  end

  defp decl_name(decl) do
    decl[:rule_name][:ident] |> Enum.at(0)
  end

  defp lookup_decl(ast, name) do
    ast |> decls()
        |> Enum.find(fn decl -> name == decl_name(decl) end)
  end

  defp escape(literal) do
    # Some literals are not correctly escaped automatically
    Regex.escape(literal) |> String.replace("/", "\\/")
  end

  defp from_rule_arm(ast, arm, visited) do
    case arm do
      [] -> {"", visited}
      [node | rest] -> case node do
        {:ident, [ident]} ->
          decl = ast |> lookup_decl(ident)
          {gen, new_visited} = ast |> from_rule_decl(decl, visited)
          {next, next_visited} = ast |> from_rule_arm(rest, new_visited)
          {gen <> next, next_visited}
        {:literal, [literal]} ->
          {next, next_visited} = ast |> from_rule_arm(rest, visited)
          escaped = escape(literal)
          {"(?:#{escaped})" <> next, next_visited}
        {:inline_regex, [inline_regex]} ->
          {next, next_visited} = ast |> from_rule_arm(rest, visited)
          {"(?:#{inline_regex})" <> next, next_visited}
        _ -> ast |> from_rule_arm(rest, visited)
      end
    end
  end

  defp from_rule_arms(ast, arms, visited) do
    case arms do
      [arm | rest] ->
        {gen, new_visited} = ast |> from_rule_arm(arm, visited)
        {next, next_visited} = ast |> from_rule_arms(rest, new_visited)
        empty = String.length(next) == 0
        {(if empty, do: gen, else: gen <> "|" <> next), next_visited}
      _ -> {"", visited}
    end
  end


  defp from_rule_decl(ast, decl, visited) do
    name = decl |> decl_name()
    if MapSet.member?(visited, name) do
      # Recursively match already-declared rule
      {"(?&#{name})", visited}
    else
      # Define new rule
      arms = decl |> Enum.map(&as_arm/1) |> Enum.reject(&is_nil/1)
      {gen, new_visited} = ast |> from_rule_arms(arms, visited |> MapSet.put(name))
      {"(?<#{name}>#{gen})", new_visited}
    end
  end

  @doc """
  Generates a (recursive) regex from the given G4 grammar AST.
  """
  def from_ast(ast, start_rule) do
    decl = ast |> lookup_decl(start_rule)
    if is_nil(decl) do
      suggestions = ast |> decls() |> Enum.map(&decl_name/1) |> Enum.join(", ")
      raise "Start symbol '" <> start_rule <> "' is not defined, try one of these: #{suggestions}"
    end
    {gen, _} = from_rule_decl(ast, decl, MapSet.new())
    gen
  end
end
