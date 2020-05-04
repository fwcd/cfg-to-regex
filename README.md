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

As a more extreme example, we can express the entire ANSI C grammar using a single regex:

<details><summary>C grammar regex</summary>

```
(?<translation_unit>(?<external_declaration>(?<function_definition>(?<declaration_specifiers>(?<storage_class_specifier>(?<TYPEDEF>(?:typedef))|(?<EXTERN>(?:extern))|(?<STATIC>(?:static))|(?<AUTO>(?:auto))|(?<REGISTER>(?:register)))|(?&storage_class_specifier)(?&declaration_specifiers)|(?<type_specifier>(?<VOID>(?:void))|(?<CHAR>(?:char))|(?<SHORT>(?:short))|(?<INT>(?:int))|(?<LONG>(?:long))|(?<FLOAT>(?:float))|(?<DOUBLE>(?:double))|(?<SIGNED>(?:signed))|(?<UNSIGNED>(?:unsigned))|(?<struct_or_union_specifier>(?<struct_or_union>(?<STRUCT>(?:struct))|(?<UNION>(?:union)))(?<IDENTIFIER>(?:[a-zA-Z0-9_]+))(?:\{)(?<struct_declaration_list>(?<struct_declaration>(?<specifier_qualifier_list>(?&type_specifier)(?&specifier_qualifier_list)|(?&type_specifier)|(?<type_qualifier>(?<CONST>(?:const))|(?<VOLATILE>(?:volatile)))(?&specifier_qualifier_list)|(?&type_qualifier))(?<struct_declarator_list>(?<struct_declarator>(?<declarator>(?<pointer>(?:\*)|(?:\*)(?<type_qualifier_list>(?&type_qualifier)|(?&type_qualifier_list)(?&type_qualifier))|(?:\*)(?&pointer)|(?:\*)(?&type_qualifier_list)(?&pointer))(?<direct_declarator>(?&IDENTIFIER)|(?:\()(?&declarator)(?:\))|(?&direct_declarator)(?:\[)(?<constant_expression>(?<conditional_expression>(?<logical_or_expression>(?<logical_and_expression>(?<inclusive_or_expression>(?<exclusive_or_expression>(?<and_expression>(?<equality_expression>(?<relational_expression>(?<shift_expression>(?<additive_expression>(?<multiplicative_expression>(?<cast_expression>(?<unary_expression>(?<postfix_expression>(?<primary_expression>(?&IDENTIFIER)|(?<CONSTANT>(?:[0-9]+))|(?<STRING_LITERAL>(?:")(?:[a-zA-Z0-9]+)(?:"))|(?:\()(?<expression>(?<assignment_expression>(?&conditional_expression)|(?&unary_expression)(?<assignment_operator>(?:=)|(?<MUL_ASSIGN>(?:\*=))|(?<DIV_ASSIGN>(?:\/=))|(?<MOD_ASSIGN>(?:%=))|(?<ADD_ASSIGN>(?:\+=))|(?<SUB_ASSIGN>(?:\-=))|(?<LEFT_ASSIGN>(?:<<=))|(?<RIGHT_ASSIGN>(?:>>=))|(?<AND_ASSIGN>(?:&=))|(?<XOR_ASSIGN>(?:\^=))|(?<OR_ASSIGN>(?:\|=)))(?&assignment_expression))|(?&expression)(?:,)(?&assignment_expression))(?:\)))|(?&postfix_expression)(?:\[)(?&expression)(?:\])|(?&postfix_expression)(?:\()(?:\))|(?&postfix_expression)(?:\()(?<argument_expression_list>(?&assignment_expression)|(?&argument_expression_list)(?:,)(?&assignment_expression))(?:\))|(?&postfix_expression)(?:\.)(?&IDENTIFIER)|(?&postfix_expression)(?<PTR_OP>(?:\->))(?&IDENTIFIER)|(?&postfix_expression)(?<INC_OP>(?:\+\+))|(?&postfix_expression)(?<DEC_OP>(?:\-\-)))|(?&INC_OP)(?&unary_expression)|(?&DEC_OP)(?&unary_expression)|(?<unary_operator>(?:&)|(?:\*)|(?:\+)|(?:\-)|(?:~)|(?:!))(?&cast_expression)|(?<SIZEOF>(?:sizeof))(?&unary_expression)|(?&SIZEOF)(?:\()(?<type_name>(?&specifier_qualifier_list)|(?&specifier_qualifier_list)(?<abstract_declarator>(?&pointer)|(?<direct_abstract_declarator>(?:\()(?&abstract_declarator)(?:\))|(?:\[)(?:\])|(?:\[)(?&constant_expression)(?:\])|(?&direct_abstract_declarator)(?:\[)(?:\])|(?&direct_abstract_declarator)(?:\[)(?&constant_expression)(?:\])|(?:\()(?:\))|(?:\()(?<parameter_type_list>(?<parameter_list>(?<parameter_declaration>(?&declaration_specifiers)(?&declarator)|(?&declaration_specifiers)(?&abstract_declarator)|(?&declaration_specifiers))|(?&parameter_list)(?:,)(?&parameter_declaration))|(?&parameter_list)(?:,)(?<ELLIPSIS>(?:\.\.\.)))(?:\))|(?&direct_abstract_declarator)(?:\()(?:\))|(?&direct_abstract_declarator)(?:\()(?&parameter_type_list)(?:\)))|(?&pointer)(?&direct_abstract_declarator)))(?:\)))|(?:\()(?&type_name)(?:\))(?&cast_expression))|(?&multiplicative_expression)(?:\*)(?&cast_expression)|(?&multiplicative_expression)(?:\/)(?&cast_expression)|(?&multiplicative_expression)(?:%)(?&cast_expression))|(?&additive_expression)(?:\+)(?&multiplicative_expression)|(?&additive_expression)(?:\-)(?&multiplicative_expression))|(?&shift_expression)(?<LEFT_OP>(?:<<))(?&additive_expression)|(?&shift_expression)(?<RIGHT_OP>(?:>>))(?&additive_expression))|(?&relational_expression)(?:<)(?&shift_expression)|(?&relational_expression)(?:>)(?&shift_expression)|(?&relational_expression)(?<LE_OP>(?:<))(?&shift_expression)|(?&relational_expression)(?<GE_OP>(?:>))(?&shift_expression))|(?&equality_expression)(?<EQ_OP>(?:==))(?&relational_expression)|(?&equality_expression)(?<NE_OP>(?:!=))(?&relational_expression))|(?&and_expression)(?:&)(?&equality_expression))|(?&exclusive_or_expression)(?:\^)(?&and_expression))|(?&inclusive_or_expression)(?:\|)(?&exclusive_or_expression))|(?&logical_and_expression)(?<AND_OP>(?:&&))(?&inclusive_or_expression))|(?&logical_or_expression)(?<OR_OP>(?:\|\|))(?&logical_and_expression))|(?&logical_or_expression)(?:\?)(?&expression)(?::)(?&conditional_expression)))(?:\])|(?&direct_declarator)(?:\[)(?:\])|(?&direct_declarator)(?:\()(?&parameter_type_list)(?:\))|(?&direct_declarator)(?:\()(?<identifier_list>(?&IDENTIFIER)|(?&identifier_list)(?:,)(?&IDENTIFIER))(?:\))|(?&direct_declarator)(?:\()(?:\)))|(?&direct_declarator))|(?::)(?&constant_expression)|(?&declarator)(?::)(?&constant_expression))|(?&struct_declarator_list)(?:,)(?&struct_declarator))(?:;))|(?&struct_declaration_list)(?&struct_declaration))(?:\})|(?&struct_or_union)(?:\{)(?&struct_declaration_list)(?:\})|(?&struct_or_union)(?&IDENTIFIER))|(?<enum_specifier>(?<ENUM>(?:enum))(?:\{)(?<enumerator_list>(?<enumerator>(?&IDENTIFIER)|(?&IDENTIFIER)(?:=)(?&constant_expression))|(?&enumerator_list)(?:,)(?&enumerator))(?:\})|(?&ENUM)(?&IDENTIFIER)(?:\{)(?&enumerator_list)(?:\})|(?&ENUM)(?&IDENTIFIER))|(?<TYPE_NAME>(?&IDENTIFIER)))|(?&type_specifier)(?&declaration_specifiers)|(?&type_qualifier)|(?&type_qualifier)(?&declaration_specifiers))(?&declarator)(?<declaration_list>(?<declaration>(?&declaration_specifiers)(?:;)|(?&declaration_specifiers)(?<init_declarator_list>(?<init_declarator>(?&declarator)|(?&declarator)(?:=)(?<initializer>(?&assignment_expression)|(?:\{)(?<initializer_list>(?&initializer)|(?&initializer_list)(?:,)(?&initializer))(?:\})|(?:\{)(?&initializer_list)(?:,)(?:\})))|(?&init_declarator_list)(?:,)(?&init_declarator))(?:;))|(?&declaration_list)(?&declaration))(?<compound_statement>(?:\{)(?:\})|(?:\{)(?<statement_list>(?<statement>(?<labeled_statement>(?&IDENTIFIER)(?::)(?&statement)|(?<CASE>(?:case))(?&constant_expression)(?::)(?&statement)|(?<DEFAULT>(?:default))(?::)(?&statement))|(?&compound_statement)|(?<expression_statement>(?:;)|(?&expression)(?:;))|(?<selection_statement>(?<IF>(?:if))(?:\()(?&expression)(?:\))(?&statement)|(?&IF)(?:\()(?&expression)(?:\))(?&statement)(?<ELSE>(?:else))(?&statement)|(?<SWITCH>(?:switch))(?:\()(?&expression)(?:\))(?&statement))|(?<iteration_statement>(?<WHILE>(?:while))(?:\()(?&expression)(?:\))(?&statement)|(?<DO>(?:do))(?&statement)(?&WHILE)(?:\()(?&expression)(?:\))(?:;)|(?<FOR>(?:for))(?:\()(?&expression_statement)(?&expression_statement)(?:\))(?&statement)|(?&FOR)(?:\()(?&expression_statement)(?&expression_statement)(?&expression)(?:\))(?&statement))|(?<jump_statement>(?<GOTO>(?:goto))(?&IDENTIFIER)(?:;)|(?<CONTINUE>(?:continue))(?:;)|(?<BREAK>(?:break))(?:;)|(?<RETURN>(?:return))(?:;)|(?&RETURN)(?&expression)(?:;)))|(?&statement_list)(?&statement))(?:\})|(?:\{)(?&declaration_list)(?:\})|(?:\{)(?&declaration_list)(?&statement_list)(?:\}))|(?&declaration_specifiers)(?&declarator)(?&compound_statement)|(?&declarator)(?&declaration_list)(?&compound_statement)|(?&declarator)(?&compound_statement))|(?&declaration))|(?&translation_unit)(?&external_declaration))
```

</details>
