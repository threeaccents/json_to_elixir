defmodule JTE.Lexer do
  @moduledoc """
  Lexer tokenizes a JSON string.
  To keep the lexer as simple as possible it expects valid JSON.
  The tokensized values are optimized to be used directly by the parser.
  """

  defguard is_whitespace(c) when c in ~c[ \r\n\t]
  defguard is_letter(c) when c in ?a..?z or c in ?A..?Z or c == ?_
  defguard is_digit(c) when c in ?0..?9
  defguard is_float_or_digit(c) when c in ?0..?9 or c == ?.
  defguard is_quote(c) when c == ?"

  def lex(input) when is_binary(input) do
    lex(input, [])
  end

  defp lex(<<>>, tokens), do: Enum.reverse([:eof | tokens])

  defp lex(<<c::8, rest::binary>>, tokens) when is_whitespace(c), do: lex(rest, tokens)

  defp lex(chars, tokens) do
    {token, rest} = tokenize(chars)

    lex(rest, [token | tokens])
  end

  defp tokenize(chars) do
    case chars do
      <<"{", rest::binary>> ->
        {:lbrace, rest}

      <<"}", rest::binary>> ->
        {:rbrace, rest}

      <<"[", rest::binary>> ->
        {:lbracket, rest}

      <<"]", rest::binary>> ->
        {:rbracket, rest}

      <<",", rest::binary>> ->
        {:comma, rest}

      <<":", rest::binary>> ->
        {:colon, rest}

      <<"\"", rest::binary>> ->
        {string, rest} = read_string(rest, <<>>)
        {{:string, string}, rest}

      <<"-", rest::binary>> ->
        {number, rest} = read_number(rest, "-")

        {{number_type(number), number}, rest}

      <<c::8, rest::binary>> when is_letter(c) ->
        {literal, rest} = read_literal(rest, <<c>>)

        case literal do
          "true" -> {{:bool, true}, rest}
          "false" -> {{:bool, false}, rest}
          "null" -> {{:null, nil}, rest}
          literal -> raise "invalid literal #{inspect(literal)}"
        end

      <<c::8, rest::binary>> when is_digit(c) ->
        {number, rest} = read_number(rest, <<c>>)

        {{number_type(number), number}, rest}

      chars ->
        raise "invalid token #{inspect(chars)}"
    end
  end

  defp read_string(<<"\"", rest::binary>>, acc) do
    {IO.iodata_to_binary(acc), rest}
  end

  defp read_string(<<c::8, rest::binary>>, acc) do
    read_string(rest, [acc | <<c>>])
  end

  defp read_literal(<<c::8, _rest::binary>> = chars, acc) when not is_letter(c) do
    {IO.iodata_to_binary(acc), chars}
  end

  defp read_literal(<<c::8, rest::binary>>, acc) do
    read_literal(rest, [acc | <<c>>])
  end

  defp read_number(<<c::8, _rest::binary>> = chars, acc) when not is_float_or_digit(c) do
    {IO.iodata_to_binary(acc), chars}
  end

  defp read_number(<<c::8, rest::binary>>, acc) do
    read_number(rest, [acc | <<c>>])
  end

  defp number_type(number) do
    if String.contains?(number, "."), do: :float, else: :integer
  end
end
