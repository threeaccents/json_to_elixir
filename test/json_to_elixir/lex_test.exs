defmodule JsonToElixir.LexTest do
  use ExUnit.Case, async: true

  alias JTE.Lexer

  describe "tokenize/1" do
    test "it tokenizes json correctly" do
      input = """
      {
      "squadName": "Super hero squad",
      "age": 12.1,
      "neg_float": -50.1,
      "neg_int": -50,
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
        {:float, "12.1"},
        :comma,
        {:string, "neg_float"},
        :colon,
        {:float, "-50.1"},
        :comma,
        {:string, "neg_int"},
        :colon,
        {:integer, "-50"},
        :comma,
        {:string, "what"},
        :colon,
        {:null, nil},
        :comma,
        {:string, "no"},
        :colon,
        {:bool, false},
        :comma,
        {:string, "formed"},
        :colon,
        {:integer, "2016"},
        :comma,
        {:string, "active"},
        :colon,
        {:bool, true},
        :comma,
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

      assert Lexer.lex(input) == exepected
    end
  end
end
