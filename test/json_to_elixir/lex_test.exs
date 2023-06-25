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
        :lbrace,
        {:string, "squadName"},
        :colon,
        {:string, "Super hero squad"},
        :comma,
        {:string, "age"},
        :colon,
        {:integer, "12.1"},
        {:string, "what"},
        :colon,
        {:null, nil},
        {:string, "no"},
        :colon,
        {:bool, false},
        {:string, "formed"},
        :colon,
        {:integer, "2016"},
        {:string, "active"},
        :colon,
        {:bool, true},
        {:string, "members"},
        :colon,
        :lbracket,
        :lbrace,
        {:string, "name"},
        :colon,
        {:string, "Molecule Man"},
        :comma,
        {:string, "powers"},
        :colon,
        :lbracket,
        {:string, "Radiation resistance"},
        :comma,
        {:string, "Turning tiny"},
        :comma,
        {:string, "Radiation blast"},
        :rbracket,
        :rbrace,
        :comma,
        :lbrace,
        {:string, "name"},
        :colon,
        {:string, "Madame Uppercut"},
        :rbrace,
        :comma,
        :lbrace,
        {:string, "name"},
        :colon,
        {:string, "Eternal Flame"},
        :rbrace,
        :rbracket,
        :rbrace,
        :eof
      ]

      assert Lexer.new(input) == exepected
    end
  end
end
