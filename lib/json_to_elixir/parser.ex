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

  def parse([%Token{type: :lbrace} | tail]) do
    {block, _tail} = parse_block(tail, [])

    {:embedded_schema, [], [[do: {:__block__, [], block}]]}
  end

  defp parse_block([], block), do: {block, []}
  defp parse_block([%Token{type: :eof}], block), do: {block, []}

  defp parse_block([%Token{type: :rbrace} | tail], block), do: {block, tail}

  defp parse_block([%Token{value: key}, _colon, %Token{type: type}, _terminator | tail], block)
       when type in @literals do
    parse_block(tail, [{:field, [], [:"#{key}", type]} | block])
  end
end
