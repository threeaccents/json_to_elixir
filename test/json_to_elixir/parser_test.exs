defmodule JsonToElixir.ParserTest do
  use ExUnit.Case, async: true

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
      "active": true,
      "child": {
          "hello": "world",
          "foo": "bar"
        }
      }
      """

      assert {:embedded_schema, [],
              [
                [
                  do:
                    {:__block__, [],
                     [
                       {:embeds_one, [],
                        [
                          :child,
                          [
                            do:
                              {:__block__, [],
                               [{:field, [], [:foo, :string]}, {:field, [], [:hello, :string]}]}
                          ]
                        ]},
                       {:field, [], [:active, :bool]},
                       {:field, [], [:formed, :integer]},
                       {:field, [], [:no, :bool]},
                       {:field, [], [:what, :null]},
                       {:field, [], [:age, :integer]},
                       {:field, [], [:squadName, :string]}
                     ]}
                ]
              ]} =
               Lexer.lex(input)
               |> Parser.parse()
    end
  end
end
