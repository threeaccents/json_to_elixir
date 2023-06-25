defmodule JsonToElixir.LexTest do
  use ExUnit.Case, async: true

  alias JTE.Token
  alias JTE.Lexer

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
      "members": [
      {
      "name": "Molecule Man",
      "powers": [
        "Radiation resistance",
        "Turning tiny",
        "Radiation blast"
      ]
      },
      {
      "name": "Madame Uppercut"
      },
      {
      "name": "Eternal Flame"
      }
      ]
      }
      """

      exepected = [
        %Token{type: :lbrace, value: "{"},
        %Token{type: :string, value: "squadName"},
        %Token{type: :colon, value: ":"},
        %Token{type: :string, value: "Super hero squad"},
        %Token{type: :comma, value: ","},
        %Token{type: :string, value: "age"},
        %Token{type: :colon, value: ":"},
        %Token{type: :integer, value: 12.1},
        %Token{type: :string, value: "what"},
        %Token{type: :colon, value: ":"},
        %Token{type: :null, value: nil},
        %Token{type: :string, value: "no"},
        %Token{type: :colon, value: ":"},
        %Token{type: :bool, value: false},
        %Token{type: :string, value: "formed"},
        %Token{type: :colon, value: ":"},
        %Token{type: :integer, value: 2016},
        %Token{type: :string, value: "active"},
        %Token{type: :colon, value: ":"},
        %Token{type: :bool, value: true},
        %Token{type: :string, value: "members"},
        %Token{type: :colon, value: ":"},
        %Token{type: :lbracket, value: "["},
        %Token{type: :lbrace, value: "{"},
        %Token{type: :string, value: "name"},
        %Token{type: :colon, value: ":"},
        %Token{type: :string, value: "Molecule Man"},
        %Token{type: :comma, value: ","},
        %Token{type: :string, value: "powers"},
        %Token{type: :colon, value: ":"},
        %Token{type: :lbracket, value: "["},
        %Token{type: :string, value: "Radiation resistance"},
        %Token{type: :comma, value: ","},
        %Token{type: :string, value: "Turning tiny"},
        %Token{type: :comma, value: ","},
        %Token{type: :string, value: "Radiation blast"},
        %Token{type: :rbracket, value: "]"},
        %Token{type: :rbrace, value: "}"},
        %Token{type: :comma, value: ","},
        %Token{type: :lbrace, value: "{"},
        %Token{type: :string, value: "name"},
        %Token{type: :colon, value: ":"},
        %Token{type: :string, value: "Madame Uppercut"},
        %Token{type: :rbrace, value: "}"},
        %Token{type: :comma, value: ","},
        %Token{type: :lbrace, value: "{"},
        %Token{type: :string, value: "name"},
        %Token{type: :colon, value: ":"},
        %Token{type: :string, value: "Eternal Flame"},
        %Token{type: :rbrace, value: "}"},
        %Token{type: :rbracket, value: "]"},
        %Token{type: :rbrace, value: "}"},
        %Token{type: :eof, value: nil}
      ]

      assert Lexer.tokenize(input) == exepected
    end
  end
end
