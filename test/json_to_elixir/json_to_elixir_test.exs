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

      expected = """
      defmodule MyJSON do
        defstruct [foo: "", bee: ""]
      end
      """

      assert expected == JTE.convert_map(input)
    end
  end
end
