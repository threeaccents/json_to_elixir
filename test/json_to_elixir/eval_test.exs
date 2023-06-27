defmodule JsonToElixir.EvalTest do
  use ExUnit.Case, async: true

  alias JTE.Eval

  describe "execute/1" do
    test "it transform ast to proper elixir code" do
      ast =
        {:embedded_schema, [],
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
                         {:__block__, [], [{:field, [], [":string_to_atom__order_id", :string]}]}
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
                                                {:field, [], [":string_to_atom__hello", :string]}
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
         ]}

      expected =
        "embedded_schema do\n  field(:id, :string)\n  field(:object, :string)\n  field(:address, :null)\n  field(:balance, :integer)\n  field(:created, :integer)\n  field(:currency, :string)\n  field(:default_source, :string)\n  field(:delinquent, :bool)\n  field(:description, :string)\n  field(:discount, :null)\n  field(:email, :string)\n  field(:invoice_prefix, :string)\n\n  embeds_one(:invoice_settings, InvoiceSettings) do\n    field(:rendering_options, :null)\n    field(:footer, :null)\n    field(:default_payment_method, :null)\n    field(:custom_fields, :null)\n  end\n\n  field(:livemode, :bool)\n\n  embeds_one(:metadata, Metadata) do\n    field(:order_id, :string)\n  end\n\n  field(:name, :null)\n  field(:next_invoice_sequence, :integer)\n  field(:phone, :null)\n  field(:shipping, :null)\n  field(:things, {:array, :integer})\n  field(:other, {:array, :string})\n  field(:tax_exempt, :string)\n  field(:test_clock, :null)\n  field(:yes, {:array, :integer})\n\n  embeds_many(:real, Real) do\n    embeds_one(:three, Three) do\n      embeds_one(:peter, Peter) do\n        field(:hello, :string)\n      end\n\n      field(:hello, :string)\n    end\n\n    field(:one, :string)\n    field(:two, :integer)\n  end\nend"

      assert expected == Eval.execute(ast)
    end
  end
end
