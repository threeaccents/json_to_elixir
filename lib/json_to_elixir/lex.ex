defmodule JTE.Lexer do
  @moduledoc """
  Lexer tokenizes a JSON string.
  To keep the lexer as simple as possible it expects valid JSON.
  The tokensized values are optimized to be used directly by the parser.
  """

  alias JTE.Token

  @lbrace 123
  @rbrace 125
  @colon 58
  @lbracket 91
  @rbracket 93
  @comma 44
  @quote 34
  @period 46

  def tokenize(input) when is_binary(input) do
    tokenize(input, [])
  end

  defp tokenize("", tokens), do: Enum.reverse([%Token{type: :eof} | tokens])

  defp tokenize(<<char::size(8), rest::binary>> = chars, tokens) do
    cond do
      is_whitespace(char) ->
        {nil, rest}

      is_left_brace(char) ->
        {%Token{type: :lbrace, value: "{"}, rest}

      is_right_brace(char) ->
        {%Token{type: :rbrace, value: "}"}, rest}

      is_colon(char) ->
        {%Token{type: :colon, value: ":"}, rest}

      is_comma(char) ->
        {%Token{type: :comma, value: ","}, rest}

      is_left_bracket(char) ->
        {%Token{type: :lbracket, value: "["}, rest}

      is_right_bracket(char) ->
        {%Token{type: :rbracket, value: "]"}, rest}

      is_quote(char) ->
        {literal, rest} = read_string(rest)

        {%Token{type: :string, value: literal}, rest}

      is_letter(char) ->
        {literal, rest} = read_literal(chars)

        case literal do
          "true" -> {%Token{type: :bool, value: true}, rest}
          "false" -> {%Token{type: :bool, value: false}, rest}
          "null" -> {%Token{type: :null, value: nil}, rest}
          _ -> raise "invalid token #{inspect(char)}"
        end

      is_digit(char) ->
        {number, rest} = read_number(chars)

        {%Token{type: :integer, value: number}, rest}
    end
    |> case do
      {%Token{} = token, chars} -> tokenize(chars, [token | tokens])
      {nil, rest} -> tokenize(rest, tokens)
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

  defp read_string(<<char::size(8), rest::binary>>, curr_literal),
    do: read_string(rest, [char | curr_literal])

  defp read_number(chars) when is_binary(chars) do
    read_number(chars, [])
  end

  defp read_number(<<char::size(8), rest::binary>>, curr_number)
       when char == @comma or char == @rbrace do
    num = Enum.reverse(curr_number)

    num =
      if Enum.any?(num, &(&1 == @period)) do
        List.to_float(num)
      else
        List.to_integer(num)
      end

    {num, rest}
  end

  defp read_number(<<char::size(8), rest::binary>>, curr_number),
    do: read_number(rest, [char | curr_number])

  defp read_literal(chars) when is_binary(chars) do
    read_literal(chars, [])
  end

  defp read_literal(<<char::size(8), rest::binary>>, curr_literal)
       when char == @comma or char == @rbrace do
    string_lit =
      curr_literal
      |> Enum.reverse()
      |> List.to_string()

    {string_lit, rest}
  end

  defp read_literal(<<char::size(8), rest::binary>>, curr_literal),
    do: read_literal(rest, [char | curr_literal])

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
