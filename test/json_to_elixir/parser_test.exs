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

      assert {:embedded_schema, [],
              [
                [
                  do:
                    {:__block__, [],
                     [
                       {:field, [], [":string_to_atom__id", :string]},
                       {:field, [], [":string_to_atom__object", :string]},
                       {:field, [], [":string_to_atom__address", :null]},
                       {:field, [], [":string_to_atom__balance", :integer]},
                       {:field, [], [":string_to_atom__created", :integer]},
                       {:field, [], [":string_to_atom__currency", :string]},
                       {:field, [], [":string_to_atom__default_source", :string]},
                       {:field, [], [":string_to_atom__delinquent", :bool]},
                       {:field, [], [":string_to_atom__description", :string]},
                       {:field, [], [":string_to_atom__discount", :null]},
                       {:field, [], [":string_to_atom__email", :string]},
                       {:field, [], [":string_to_atom__invoice_prefix", :string]},
                       {:embeds_one, [],
                        [
                          ":string_to_atom__invoice_settings",
                          {:__aliases__, [], [":string_to_atom__InvoiceSettings"]},
                          [
                            do:
                              {:__block__, [],
                               [
                                 {:field, [], [":string_to_atom__rendering_options", :null]},
                                 {:field, [], [":string_to_atom__footer", :null]},
                                 {:field, [], [":string_to_atom__default_payment_method", :null]},
                                 {:field, [], [":string_to_atom__custom_fields", :null]}
                               ]}
                          ]
                        ]},
                       {:field, [], [":string_to_atom__livemode", :bool]},
                       {:embeds_one, [],
                        [
                          ":string_to_atom__metadata",
                          {:__aliases__, [], [":string_to_atom__Metadata"]},
                          [
                            do:
                              {:__block__, [],
                               [{:field, [], [":string_to_atom__order_id", :string]}]}
                          ]
                        ]},
                       {:field, [], [":string_to_atom__name", :null]},
                       {:field, [], [":string_to_atom__next_invoice_sequence", :integer]},
                       {:field, [], [":string_to_atom__phone", :null]},
                       {:field, [], [":string_to_atom__shipping", :null]},
                       {:field, [], [":string_to_atom__things", {:array, :integer}]},
                       {:field, [], [":string_to_atom__other", {:array, :string}]},
                       {:field, [], [":string_to_atom__tax_exempt", :string]},
                       {:field, [], [":string_to_atom__test_clock", :null]},
                       {:field, [], [":string_to_atom__yes", {:array, :integer}]},
                       {:embeds_many, [],
                        [
                          ":string_to_atom__real",
                          {:__aliases__, [], [":string_to_atom__Real"]},
                          [
                            do:
                              {:__block__, [],
                               [
                                 {:embeds_one, [],
                                  [
                                    ":string_to_atom__three",
                                    {:__aliases__, [], [":string_to_atom__Three"]},
                                    [
                                      do:
                                        {:__block__, [],
                                         [
                                           {:embeds_one, [],
                                            [
                                              ":string_to_atom__peter",
                                              {:__aliases__, [], [":string_to_atom__Peter"]},
                                              [
                                                do:
                                                  {:__block__, [],
                                                   [
                                                     {:field, [],
                                                      [":string_to_atom__hello", :string]}
                                                   ]}
                                              ]
                                            ]},
                                           {:field, [], [":string_to_atom__hello", :string]}
                                         ]}
                                    ]
                                  ]},
                                 {:field, [], [":string_to_atom__one", :string]},
                                 {:field, [], [":string_to_atom__two", :integer]}
                               ]}
                          ]
                        ]}
                     ]}
                ]
              ]} =
               input
               |> Lexer.lex()
               |> Parser.parse()
    end
  end
end
