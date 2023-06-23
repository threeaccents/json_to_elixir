defmodule JTETest do
  use ExUnit.Case, async: true

  describe "traverse_map" do
    test "one" do
      input = %{
        "data" => [
          %{
            "attributes" => %{
              "body" => "The shortest article. Ever.",
              "created" => "2015-05-22T14:56:29.000Z",
              "title" => "JSON:API paints my bikeshed!",
              "updated" => "2015-05-22T14:56:28.000Z"
            },
            "id" => "1",
            "relationships" => %{
              "author" => %{"data" => %{"id" => "42", "type" => "people"}}
            },
            "type" => "articles"
          }
        ],
        "included" => [
          %{
            "attributes" => %{"age" => 80, "gender" => "male", "name" => "John"},
            "id" => "42",
            "type" => "people"
          }
        ]
      }

      input = """
      {
      "squadName": "Super hero squad",
      "homeTown": "Metro City",
      "formed": 2016,
      "secretBase": "Super tower",
      "active": true,
      "members": [
      {
      "name": "Molecule Man",
      "age": 29,
      "secretIdentity": "Dan Jukes",
      "powers": ["Radiation resistance", "Turning tiny", "Radiation blast"]
      },
      {
      "name": "Madame Uppercut",
      "age": 39,
      "secretIdentity": "Jane Wilson",
      "powers": [
        "Million tonne punch",
        "Damage resistance",
        "Superhuman reflexes"
      ]
      },
      {
      "name": "Eternal Flame",
      "age": 1000000,
      "secretIdentity": "Unknown",
      "powers": [
        "Immortality",
        "Heat Immunity",
        "Inferno",
        "Teleportation",
        "Interdimensional travel"
      ]
      }
      ]
      }

      """

      expected = """
      defmodule MyJSON do
        defstruct [foo: "", bee: ""]
      end
      """

      assert expected == JTE.convert_map(input)
    end
  end
end
