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
                       {:field, [], [:id, :string]},
                       {:field, [], [:object, :string]},
                       {:field, [], [:address, :null]},
                       {:field, [], [:balance, :integer]},
                       {:field, [], [:created, :integer]},
                       {:field, [], [:currency, :string]},
                       {:field, [], [:default_source, :string]},
                       {:field, [], [:delinquent, :bool]},
                       {:field, [], [:description, :string]},
                       {:field, [], [:discount, :null]},
                       {:field, [], [:email, :string]},
                       {:field, [], [:invoice_prefix, :string]},
                       {:embeds_one, [],
                        [
                          :invoice_settings,
                          {:__aliases__, [], [:InvoiceSettings]},
                          [
                            do:
                              {:__block__, [],
                               [
                                 {:field, [], [:rendering_options, :null]},
                                 {:field, [], [:footer, :null]},
                                 {:field, [], [:default_payment_method, :null]},
                                 {:field, [], [:custom_fields, :null]}
                               ]}
                          ]
                        ]},
                       {:field, [], [:livemode, :bool]},
                       {:embeds_one, [],
                        [
                          :metadata,
                          {:__aliases__, [], [:Metadata]},
                          [do: {:__block__, [], [{:field, [], [:order_id, :string]}]}]
                        ]},
                       {:field, [], [:name, :null]},
                       {:field, [], [:next_invoice_sequence, :integer]},
                       {:field, [], [:phone, :null]},
                       {:field, [], [:shipping, :null]},
                       {:field, [], [:things, {:array, :integer}]},
                       {:field, [], [:other, {:array, :string}]},
                       {:field, [], [:tax_exempt, :string]},
                       {:field, [], [:test_clock, :null]},
                       {:field, [], [:yes, {:array, :integer}]},
                       {:embeds_many, [],
                        [
                          :real,
                          {:__aliases__, [], [:Real]},
                          [
                            do:
                              {:__block__, [],
                               [
                                 {:embeds_one, [],
                                  [
                                    :three,
                                    {:__aliases__, [], [:Three]},
                                    [
                                      do:
                                        {:__block__, [],
                                         [
                                           {:embeds_one, [],
                                            [
                                              :peter,
                                              {:__aliases__, [], [:Peter]},
                                              [
                                                do:
                                                  {:__block__, [],
                                                   [{:field, [], [:hello, :string]}]}
                                              ]
                                            ]},
                                           {:field, [], [:hello, :string]}
                                         ]}
                                    ]
                                  ]},
                                 {:field, [], [:one, :string]},
                                 {:field, [], [:two, :integer]}
                               ]}
                          ]
                        ]}
                     ]}
                ]
              ]} =
               Lexer.lex(input)
               |> Parser.parse()
    end
  end
end
