defmodule JsonToElixir.ParserTest do
  use ExUnit.Case, async: true

  alias JTE.Token
  alias JTE.Lexer
  alias JTE.Parser

  describe "tokenize/1" do
    test "it tokenizes json correctly" do
      input = """
      {
      "squadName": "Super hero squad",
      "age": 12.1,
      "what": null,
      "no": false,
      "formed": 2016,
      "active": true
      }
      """

      Lexer.tokenize(input)
      |> IO.inspect(label: :yo)
      |> Parser.parse()
    end
  end
end
