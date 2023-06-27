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
                       {:field, [], [":string_to_atom__address", :string]},
                       {:field, [], [":string_to_atom__balance", :integer]},
                       {:field, [], [":string_to_atom__created", :integer]},
                       {:field, [], [":string_to_atom__currency", :string]},
                       {:field, [], [":string_to_atom__default_source", :string]},
                       {:field, [], [":string_to_atom__delinquent", :bool]},
                       {:field, [], [":string_to_atom__description", :string]},
                       {:field, [], [":string_to_atom__discount", :string]},
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
                                 {:field, [], [":string_to_atom__rendering_options", :string]},
                                 {:field, [], [":string_to_atom__footer", :string]},
                                 {:field, [],
                                  [":string_to_atom__default_payment_method", :string]},
                                 {:field, [], [":string_to_atom__custom_fields", :string]}
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
                       {:field, [], [":string_to_atom__name", :string]},
                       {:field, [], [":string_to_atom__next_invoice_sequence", :integer]},
                       {:field, [], [":string_to_atom__phone", :string]},
                       {:field, [], [":string_to_atom__shipping", :string]},
                       {:field, [], [":string_to_atom__things", {:array, :integer}]},
                       {:field, [], [":string_to_atom__other", {:array, :string}]},
                       {:field, [], [":string_to_atom__tax_exempt", :string]},
                       {:field, [], [":string_to_atom__test_clock", :string]},
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

    test "nested json arrays" do
      input = """
      {
      "id": "ochOrder::2327eee7-f4e8-48c0-ae8f-7a6550b46a79",
      "type": "acknowledgement",
      "items": [
      {
      "materialId": "04062139001712",
      "taxDetails": [],
      "adjustments": [],
      "confirmedQty": 1596,
      "fulfillments": [],
      "requestedQty": 1596,
      "pepMaterialId": "000000000340044271",
      "discountDetails": [],
      "requestedQtyUom": "CS",
      "unitPriceAmount": 0.01,
      "bundleComponents": [],
      "referenceOrderId": "AMAZON",
      "sourceOrderLineId": "13539365",
      "orderLineSequenceNo": "1bc75fa9-703c-49ea-864f-278e0e3b2405",
      "referenceOrderLineNumber": "000010",
      "extendedItemAttributesMap": {},
      "extendedItemAttributesList": []
      }
      ],
      "addresses": [
      {
      "cityName": "Bad Hersfeld",
      "postalArea": "36251",
      "addressType": "Shipping",
      "addressLine1": "Am Schloss Eichhof 1",
      "countryIsoName": "US",
      "deliveryInstructions": "No Shipping Instructions"
      }
      ],
      "discounts": [],
      "orderType": "ZFD",
      "statusCode": "NEW",
      "adjustments": [],
      "createdById": "0oajcibafnhD1nxUV2p7",
      "typeVersion": "v1",
      "validations": [],
      "customerPoId": "77BLSM7N",
      "modifiedById": "OCH_ORDER_SERVICE_SYSTEM",
      "orderUniqueId": "ochOrder::2327eee7-f4e8-48c0-ae8f-7a6550b46a79::v1",
      "sourceOrderId": "77BLSM7N",
      "orderSubStatus": "ACKNOWLEDGED",
      "sourceSystemId": "1072",
      "createdDateTime": "2023-06-20T00:00:00Z",
      "orderLocationId": "4323",
      "sourceProfileId": "5L75Q",
      "updatedDateTime": "2023-06-22T10:50:11.378Z",
      "alternateOrderId": "1089003894",
      "consumerPayments": [],
      "publicRemarkText": "No Public Remark",
      "receivedDateTime": "2023-06-22T10:45:04.353Z",
      "shipToCustomerId": "400028789",
      "soldToCustomerId": "200595239",
      "reasonDescription": "Order received succesfully",
      "marketPlaceOrderId": "77BLSM7N",
      "privateRemarksText": "No Private Remarks",
      "alternateLocationId": "4323",
      "marketPlaceSiteName": "AMAZON",
      "extendedAttributesMap": {
      "division": "01",
      "distributionChannel": "02"
      },
      "externalTransactionId": "v1::Tv8LOlEtb8GBdW/J15LoDTfzE4hI8pfODPxixe939xc=",
      "orderProcessingStatus": "ORDER_ACKNOWLEDGED_BY_SAP",
      "salesOrganizationCode": "DE03",
      "extendedAttributesList": [],
      "requestedDeliveryDateTime": "2023-06-30T00:00:00Z",
      "orderProcessingStatusReason": "Order acknowledged by SAP"
      }
      """

      assert {:embedded_schema, [],
              [
                [
                  do:
                    {:__block__, [],
                     [
                       {:field, [], [":string_to_atom__id", :string]},
                       {:field, [], [":string_to_atom__type", :string]},
                       {:embeds_many, [],
                        [
                          ":string_to_atom__items",
                          {:__aliases__, [], [":string_to_atom__Items"]},
                          [
                            do:
                              {:__block__, [],
                               [
                                 {:embeds_many, [],
                                  [
                                    ":string_to_atom__extendedItemAttributesList",
                                    {:__aliases__, [],
                                     [":string_to_atom__ExtendedItemAttributesList"]},
                                    [do: {:__block__, [], []}]
                                  ]},
                                 {:embeds_one, [],
                                  [
                                    ":string_to_atom__extendedItemAttributesMap",
                                    {:__aliases__, [],
                                     [":string_to_atom__ExtendedItemAttributesMap"]},
                                    [do: {:__block__, [], []}]
                                  ]},
                                 {:field, [],
                                  [":string_to_atom__referenceOrderLineNumber", :string]},
                                 {:field, [], [":string_to_atom__orderLineSequenceNo", :string]},
                                 {:field, [], [":string_to_atom__sourceOrderLineId", :string]},
                                 {:field, [], [":string_to_atom__referenceOrderId", :string]},
                                 {:embeds_many, [],
                                  [
                                    ":string_to_atom__bundleComponents",
                                    {:__aliases__, [], [":string_to_atom__BundleComponents"]},
                                    [do: {:__block__, [], []}]
                                  ]},
                                 {:field, [], [":string_to_atom__unitPriceAmount", :integer]},
                                 {:field, [], [":string_to_atom__requestedQtyUom", :string]},
                                 {:embeds_many, [],
                                  [
                                    ":string_to_atom__discountDetails",
                                    {:__aliases__, [], [":string_to_atom__DiscountDetails"]},
                                    [do: {:__block__, [], []}]
                                  ]},
                                 {:field, [], [":string_to_atom__pepMaterialId", :string]},
                                 {:field, [], [":string_to_atom__requestedQty", :integer]},
                                 {:embeds_many, [],
                                  [
                                    ":string_to_atom__fulfillments",
                                    {:__aliases__, [], [":string_to_atom__Fulfillments"]},
                                    [do: {:__block__, [], []}]
                                  ]},
                                 {:field, [], [":string_to_atom__confirmedQty", :integer]},
                                 {:embeds_many, [],
                                  [
                                    ":string_to_atom__adjustments",
                                    {:__aliases__, [], [":string_to_atom__Adjustments"]},
                                    [do: {:__block__, [], []}]
                                  ]},
                                 {:embeds_many, [],
                                  [
                                    ":string_to_atom__taxDetails",
                                    {:__aliases__, [], [":string_to_atom__TaxDetails"]},
                                    [do: {:__block__, [], []}]
                                  ]},
                                 {:field, [], [":string_to_atom__materialId", :string]}
                               ]}
                          ]
                        ]},
                       {:embeds_many, [],
                        [
                          ":string_to_atom__addresses",
                          {:__aliases__, [], [":string_to_atom__Addresses"]},
                          [
                            do:
                              {:__block__, [],
                               [
                                 {:field, [], [":string_to_atom__deliveryInstructions", :string]},
                                 {:field, [], [":string_to_atom__countryIsoName", :string]},
                                 {:field, [], [":string_to_atom__addressLine1", :string]},
                                 {:field, [], [":string_to_atom__addressType", :string]},
                                 {:field, [], [":string_to_atom__postalArea", :string]},
                                 {:field, [], [":string_to_atom__cityName", :string]}
                               ]}
                          ]
                        ]},
                       {:field, [], [":string_to_atom__discounts", {:array, :string}]},
                       {:field, [], [":string_to_atom__orderType", :string]},
                       {:field, [], [":string_to_atom__statusCode", :string]},
                       {:field, [], [":string_to_atom__adjustments", {:array, :string}]},
                       {:field, [], [":string_to_atom__createdById", :string]},
                       {:field, [], [":string_to_atom__typeVersion", :string]},
                       {:field, [], [":string_to_atom__validations", {:array, :string}]},
                       {:field, [], [":string_to_atom__customerPoId", :string]},
                       {:field, [], [":string_to_atom__modifiedById", :string]},
                       {:field, [], [":string_to_atom__orderUniqueId", :string]},
                       {:field, [], [":string_to_atom__sourceOrderId", :string]},
                       {:field, [], [":string_to_atom__orderSubStatus", :string]},
                       {:field, [], [":string_to_atom__sourceSystemId", :string]},
                       {:field, [], [":string_to_atom__createdDateTime", :string]},
                       {:field, [], [":string_to_atom__orderLocationId", :string]},
                       {:field, [], [":string_to_atom__sourceProfileId", :string]},
                       {:field, [], [":string_to_atom__updatedDateTime", :string]},
                       {:field, [], [":string_to_atom__alternateOrderId", :string]},
                       {:field, [], [":string_to_atom__consumerPayments", {:array, :string}]},
                       {:field, [], [":string_to_atom__publicRemarkText", :string]},
                       {:field, [], [":string_to_atom__receivedDateTime", :string]},
                       {:field, [], [":string_to_atom__shipToCustomerId", :string]},
                       {:field, [], [":string_to_atom__soldToCustomerId", :string]},
                       {:field, [], [":string_to_atom__reasonDescription", :string]},
                       {:field, [], [":string_to_atom__marketPlaceOrderId", :string]},
                       {:field, [], [":string_to_atom__privateRemarksText", :string]},
                       {:field, [], [":string_to_atom__alternateLocationId", :string]},
                       {:field, [], [":string_to_atom__marketPlaceSiteName", :string]},
                       {:embeds_one, [],
                        [
                          ":string_to_atom__extendedAttributesMap",
                          {:__aliases__, [], [":string_to_atom__ExtendedAttributesMap"]},
                          [
                            do:
                              {:__block__, [],
                               [
                                 {:field, [], [":string_to_atom__distributionChannel", :string]},
                                 {:field, [], [":string_to_atom__division", :string]}
                               ]}
                          ]
                        ]},
                       {:field, [], [":string_to_atom__externalTransactionId", :string]},
                       {:field, [], [":string_to_atom__orderProcessingStatus", :string]},
                       {:field, [], [":string_to_atom__salesOrganizationCode", :string]},
                       {:field, [],
                        [":string_to_atom__extendedAttributesList", {:array, :string}]},
                       {:field, [], [":string_to_atom__requestedDeliveryDateTime", :string]},
                       {:field, [], [":string_to_atom__orderProcessingStatusReason", :string]}
                     ]}
                ]
              ]} =
               Lexer.lex(input)
               |> Parser.parse()
    end
  end
end
