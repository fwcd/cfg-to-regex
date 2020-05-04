# CFG to Regex Compiler
A small tool to convert context-free grammars (written in ANTLR syntax) into a regex.

Modern regex engines support many features that exceed the expressiveness of classic regular expressions, e.g. recursion, backreferences and lookaround, thus making it possible to encode arbitrary CFGs in a single regex.

Hence the generated regex requires the following features:

* **Recursion** to encode arbitrary context-free productions
    * represented as `(?&name)` where `name` is the name of a capturing group
* **Named capturing groups** to encode the rule names
    * represented as `(?<name>...)` where `name` defines the name of the capturing group

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
To build the application, run `mix escript.build` to generate an executable.

## Usage
This executable only requires the Erlang runtime to be installed on the system and can be invoked directly or using `escript`:

`escript cfg_to_regex [start rule] [path/to/grammar.g4]`

## Example
Sample grammars can be found in the `examples` directory. For example does the following context-free (and non-regular) grammar:

```antlr
hello : 'Hello';
world : 'World';
hello_world : hello hello_world world | ', ';
```

...compile to the following regex:

```
(?<hello_world>(?<hello>(?:Hello))(?&hello_world)(?<world>(?:World))|(?:, ))
```
