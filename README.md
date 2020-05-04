# CFG to Regex Compiler
A small tool to convert context-free grammars (written in ANTLR syntax) into a regex.

Modern regex engines support many features that exceed the expressiveness of classic regular expressions, e.g. recursion, backreferences and lookaround, thus making it possible to encode arbitrary CFGs in a single regex.

## Installation
If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cfg_to_regex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cfg_to_regex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/cfg_to_regex](https://hexdocs.pm/cfg_to_regex).

## Building
To build the application, run `mix escript.build` to generate an executable. This executable only requires the Erlang runtime to be installed on the system and can be invoked directly or used `escript`:

`escript cfg_to_regex [path/to/grammar.g4]`
