defmodule JTE.Parser do
  @moduledoc """
  JSON parser. 
  It expects the tokens generarted by the lexer.
  Since the lexer only takes in valid JSON the parser
  can expect to receive only valid tokens.
  """
  @literals ~w(string integer float null bool)a

  def parse([]) do
    {:embedded_schema, [], [[do: {:__block__, [], []}]]}
  end

  def parse([:lbrace | tail]) do
    {blocks, _tail} = parse_block(tail, [])

    {:embedded_schema, [], [[do: {:__block__, [], Enum.reverse(blocks)}]]}
  end

  defp parse_block([:rbrace | tail], blocks), do: {blocks, maybe_pop_comma(tail)}

  # Ex. "key": "value",
  defp parse_block([{_, key}, :colon, {value_type, _}, :comma | tail], blocks) do
    blocks = [{:field, [], [:"#{key}", value_type]} | blocks]
    parse_block(tail, blocks)
  end

  # Ex. "key": "value"}
  defp parse_block([{_, key}, :colon, {value_type, _}, :rbrace | tail], blocks) do
    blocks = [{:field, [], [:"#{key}", value_type]} | blocks]
    parse_block([:rbrace | tail], blocks)
  end

  # Ex. "key": {
  defp parse_block([{_, key}, :colon, :lbrace | tail], blocks) do
    {inner_blocks, rest} = parse_block(tail, [])

    blocks = [
      {:embeds_one, [],
       [
         :"#{key}",
         {:__aliases__, [], [Macro.camelize(key) |> String.to_atom()]},
         [do: {:__block__, [], inner_blocks}]
       ]}
      | blocks
    ]

    parse_block(rest, blocks)
  end

  # Ex. "key": [""]; or "key": [12]
  defp parse_block([{_, key}, :colon, :lbracket, {array_type, _} | tail], blocks) do
    tail = eat_until(tail, :rbracket)

    # we set the array to the type of the first item in the array
    blocks = [
      {:field, [], [:"#{key}", {:array, array_type}]} | blocks
    ]

    parse_block(maybe_pop_comma(tail), blocks)
  end

  # Ex. "key": []
  defp parse_block([{_, key}, :colon, :lbracket, :rbracket | tail], blocks) do
    blocks = [
      {:field, [], [:"#{key}", {:array, :string}]} | blocks
    ]

    parse_block(maybe_pop_comma(tail), blocks)
  end

  # Ex."key": [{
  defp parse_block([{_, key}, :colon, :lbracket, :lbrace | tail], blocks) do
    # traverse all objects in array.
    # keep a table of all fields used in the array.
    # This allows us to grab all items from all objects in the array

    # [{"foo": "bar"}, {"baz": 12}]
    # should produce
    # ... do
    # field :foo, :string
    # field :baz, :integer
    # end
    {inner_blocks, tail} = parse_array_block(tail, [], %{})

    blocks = [
      {:embeds_many, [], [:"#{key}", Macro.camelize(key), [do: {:__block__, [], inner_blocks}]]}
      | blocks
    ]

    parse_block(maybe_pop_comma(tail), blocks)
  end

  defp parse_array_block([:rbracket | tail], blocks, _block_table) do
    {blocks, tail}
  end

  defp eat_until([], _), do: []
  defp eat_until([token | tail], terminator) when token == terminator, do: tail
  defp eat_until([_ | tail], terminator), do: eat_until(tail, terminator)

  defp maybe_pop_comma([:comma | tail]), do: tail
  defp maybe_pop_comma(tokens), do: tokens
end
