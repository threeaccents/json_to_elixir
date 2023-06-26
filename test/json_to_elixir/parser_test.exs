defmodule JsonToElixir.ParserTest do
  use ExUnit.Case, async: true

  alias JTE.Lexer
  alias JTE.Parser

  describe "tokenize/1" do
    test "it tokenizes json correctly" do
      input = """
      {
      "id": "cus_9s6XFG2Qq6Fe7v",
      "object": "customer",
      "address": null,
      "balance": 0,
      "created": 1483565364,
      "currency": "usd",
      "default_source": "card_1NLMwb2eZvKYlo2CrEVATdxC",
      "delinquent": false,
      "description": "Jamarcus Donnelly",
      "discount": null,
      "email": "user1850@smithpadberg.io",
      "invoice_prefix": "E3C5260",
      "invoice_settings": {
      "custom_fields": null,
      "default_payment_method": null,
      "footer": null,
      "rendering_options": null
      },
      "livemode": false,
      "metadata": {
      "order_id": "673345234234234"
      },
      "name": null,
      "next_invoice_sequence": 6,
      "phone": null,
      "shipping": null,
      "things": [1,2],
      "other": [],
      "tax_exempt": "none",
      "test_clock": null,
      "yes": [1,2,3],
      "real": [
      {"one": "2"},
      {"two": 3},
      {"one": "three"},
      {"three": {
                  "hello": "wpr;da",
                  "peter": {
                    "hello": "world"
                  }
                }}
      ]
      }
      """

      Lexer.lex(input)
      |> Parser.parse()
      |> Macro.to_string()
      |> IO.puts()
    end
  end
end
