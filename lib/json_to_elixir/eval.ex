defmodule JTE.Eval do
  @moduledoc """
  Eval turns the AST into formatted Elixir code.
  """

  def execute(ast) do
    ast
    |> Macro.to_string()
    |> replace_atoms()
  end

  def transform_schema(input) do
    Regex.replace(~r/\"\:string_to_atom__(\w+)\"/, input, "\\0", [])
  end

  def replace_atoms(input) do
    input = Regex.replace(~r/\":string_to_atom__(\w+)\"/, input, ":\\1")
    input = Regex.replace(~r/field\(":(\w+)",/, input, "field(:\\1,")
    input = Regex.replace(~r/embeds_one\(":(\w+)",/, input, "embeds_one(\\1,")
    input = Regex.replace(~r/embeds_many\(":(\w+)",/, input, "embeds_many(\\1,")
    Regex.replace(~r/:([A-Z|0-9]+)/, input, "\\1")
  end
end