defmodule JTE.Lexer do
  @input """

        {
        "squadName": "Super hero squad",
        "homeTown": "Metro City",
        "formed": 2016,
        "secretBase": "Super tower",
        "active": true,
        "members": [
        {
        "name": "Molecule Man",
        "age": 29,
        "secretIdentity": "Dan Jukes",
        "powers": ["Radiation resistance", "Turning tiny", "Radiation blast"]
        },
        {
        "name": "Madame Uppercut",
        "age": 39,
        "secretIdentity": "Jane Wilson",
        "powers": [
          "Million tonne punch",
          "Damage resistance",
          "Superhuman reflexes"
        ]
        },
        {
        "name": "Eternal Flame",
        "age": 1000000,
        "secretIdentity": "Unknown",
        "powers": [
          "Immortality",
          "Heat Immunity",
          "Inferno",
          "Teleportation",
          "Interdimensional travel"
        ]
        }
        ]
        }
  """

  def tokenize(), do: tokenize(@input)

  def tokenize(input) when is_binary(input) do
    tokenize(input, [])
  end

  defp tokenize("", tokens), do: Enum.reverse([{:eof, nil} | tokens])

  defp tokenize(<<ch::size(8), rest::binary>> = chars, tokens) do
    {token, chars} =
      cond do
        is_whitespace(ch) ->
          {nil, rest}

        is_quote(ch) ->
          {str_literal, rest} = read_string(rest)

          {{:string, str_literal}, rest}

        is_digit(ch) ->
          {number, rest} = read_number(chars)
          {{:number, number}, rest}

        is_letter(ch) ->
          {literal, rest} = read_identifier(chars)

          {{:bool, literal}, rest}

        true ->
          {{symbol(ch), ch}, rest}
      end

    if token != nil do
      tokenize(chars, [token | tokens])
    else
      tokenize(chars, tokens)
    end
  end

  defp read_string(<<word::binary, "\"", rest::binary>>) do
    {word, rest}
  end

  defp read_number(chars) do
    {number, rest} = Enum.split_while(chars, &is_digit/1)
    number = Enum.join(number)

    {number, rest}
  end

  defp read_identifier(chars) do
    {identifier, rest} = Enum.split_while(chars, &is_letter/1)
    identifier = Enum.join(identifier)

    case identifier do
      "true" -> {true, rest}
      "false" -> {false, rest}
      _ -> raise "invalid character"
    end
  end

  defp symbol(123), do: :lbrace
  defp symbol(125), do: :rbrace
  defp symbol(58), do: :colon
  defp symbol(91), do: :lbracket
  defp symbol(93), do: :rbracket
  defp symbol(44), do: :comma

  defp is_digit(ch) do
    ch >= 48 and ch <= 57
  end

  defp is_letter(ch) do
    (ch >= 65 and ch <= 90) or (ch >= 97 and ch <= 122)
  end

  defp is_whitespace(ch) do
    ch == 32 || ch == 10 || ch == 9
  end

  defp is_quote(ch), do: ch == 34
end
