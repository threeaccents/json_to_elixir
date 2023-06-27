defmodule JTE.Eval do
  @moduledoc """
  Eval turns the AST into formatted Elixir code.

  It replaces the atom placeholder for "real" atoms.
  Since we transform the AST into a string we still not actually creating atoms.
  We are just parsing the string to make it look like an atom.
  """

  def execute(ast) do
    ast
    |> Macro.to_string()
    |> replace_atom_placeholders()
  end

  def replace_atom_placeholders(input) do
    input = Regex.replace(~r/\":string_to_atom__(\w+)\"/, input, ":\\1")
    input = Regex.replace(~r/field\(":(\w+)",/, input, "field(:\\1,")
    input = Regex.replace(~r/embeds_one\(":(\w+)",/, input, "embeds_one(\\1,")
    input = Regex.replace(~r/embeds_many\(":(\w+)",/, input, "embeds_many(\\1,")
    Regex.replace(~r/:([A-Z|0-9]+)/, input, "\\1")
  end
end
