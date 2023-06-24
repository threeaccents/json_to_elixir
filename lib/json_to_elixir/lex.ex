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
  @lbrace 123
  @rbrace 125
  @colon 58
  @lbracket 91
  @rbracket 93
  @comma 44
  @quote 34

  def tokenize(input) when is_binary(input) do
    tokenize(input, [])
  end

  defp tokenize("", tokens), do: tokens

  defp tokenize(<<char::size(8), rest::binary>>, tokens) do
    cond do
      is_whitespace(char) ->
        tokenize(rest, tokens)

      is_left_brace(char) ->
        {{:lbrace, "{"}, rest}

      is_right_brace(char) ->
        {{:rbrace, "}"}, rest}

      is_colon(char) ->
        {{:colon, ":"}, rest}

      is_comma(char) ->
        {{:comma, ","}, rest}

      is_left_bracket(char) ->
        {{:lbracket, "["}, rest}

      is_right_bracket(char) ->
        {{:rbracket, "]"}, rest}

      is_quote(char) ->
        {literal, rest} = read_string(rest)

        {{:string, literal}, rest}

      is_letter(char) ->
        nil
    end
  end

  defp read_string(chars) when is_binary(chars) do
    read_string(chars, [])
  end

  defp read_string(<<char::size(8), rest::binary>>, curr_literal) when char == @quote do
    string_lit =
      curr_literal
      |> Enum.reverse()
      |> List.to_string()

    {string_lit, rest}
  end

  defp read_literal(chars) when is_binary(chars) do
    read_literal(chars, [])
  end

  defp read_literal(<<char::size(8), rest::binary>>, curr_literal) when char == @comma do
    string_lit =
      curr_literal
      |> Enum.reverse()
      |> List.to_string()

    {string_lit, rest}
  end

  defp read_li

  defp read_string(<<char::size(8), rest::binary>>, curr_literal),
    do: read_string(rest, [char | curr_literal])

  defp is_left_brace(char), do: char == @lbrace
  defp is_right_brace(char), do: char == @rbrace
  defp is_colon(char), do: char == @colon
  defp is_comma(char), do: char == @comma
  defp is_left_bracket(char), do: char == @lbracket
  defp is_right_bracket(char), do: char == @rbracket

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
