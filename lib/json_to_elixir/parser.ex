defmodule JTE.Parser do
  @moduledoc """
  JSON parser. 
  It expects the tokens generarted by the lexer.
  Since the lexer only takes in valid JSON the parser
  can expect to receive only valid tokens.
  """
  alias JTE.Token

  @literals ~w(string integer float null bool)a

  def parse([]), do: nil

  def parse([:eof]), do: nil

  def parse([:lbrace | tail]) do
    {block, _tail} = parse_block(tail, [])

    {:embedded_schema, [], [[do: {:__block__, [], block}]]}
  end

  defp parse_block([], block), do: {block, []}
  defp parse_block([:eof], block), do: {block, []}

  defp parse_block([:rbrace | tail], block), do: {block, tail}
  defp parse_block([:rbracket | tail], block), do: {block, tail}

  defp parse_block([{_type, key}, _colon, {type, _}, _terminator | tail], block)
       when type in @literals do
    parse_block(tail, [{:field, [], [:"#{key}", type]} | block])
  end

  defp parse_block([{_type, key}, _colon, :lbracket | tail], block) do
    {inner_block, tail} = parse_block(tail, [])

    parse_block(tail, [
      {:embeds_many, [],
       [
         :"#{key}",
         {:__aliases__, [], [key |> Macro.camelize() |> String.to_atom()]},
         [do: {:__block__, [], inner_block}]
       ]}
      | block
    ])
  end

  defp parse_block([{_type, key}, _colon, :lbrace | tail], block) do
    {inner_block, tail} = parse_block(tail, [])

    parse_block(tail, [
      {:embeds_one, [],
       [
         :"#{key}",
         {:__aliases__, [], [key |> Macro.camelize() |> String.to_atom()]},
         [do: {:__block__, [], inner_block}]
       ]}
      | block
    ])
  end
end
