defmodule JTETest do
  use ExUnit.Case, async: true

  describe "transform/1" do
    test "it transoform JSON to elixir code" do
      json = """
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

      expected_code =
        "embedded_schema do\n  field(:address, :string)\n  field(:balance, :integer)\n  field(:created, :integer)\n  field(:currency, :string)\n  field(:default_source, :string)\n  field(:delinquent, :boolean)\n  field(:description, :string)\n  field(:discount, :string)\n  field(:email, :string)\n  field(:id, :string)\n  field(:invoice_prefix, :string)\n\n  embeds_one(:invoice_settings, InvoiceSettings) do\n    field(:rendering_options, :string)\n    field(:footer, :string)\n    field(:default_payment_method, :string)\n    field(:custom_fields, :string)\n  end\n\n  field(:livemode, :boolean)\n\n  embeds_one(:metadata, Metadata) do\n    field(:order_id, :string)\n  end\n\n  field(:name, :string)\n  field(:next_invoice_sequence, :integer)\n  field(:object, :string)\n  field(:other, {:array, :string})\n  field(:phone, :string)\n\n  embeds_many(:real, Real) do\n    embeds_one(:three, Three) do\n      embeds_one(:peter, Peter) do\n        field(:hello, :string)\n      end\n\n      field(:hello, :string)\n    end\n\n    field(:one, :string)\n    field(:two, :integer)\n  end\n\n  field(:shipping, :string)\n  field(:tax_exempt, :string)\n  field(:test_clock, :string)\n  field(:things, {:array, :integer})\n  field(:yes, {:array, :integer})\nend"

      assert {:ok, code} = JTE.transform(json)
      assert code == expected_code
    end
  end
end
