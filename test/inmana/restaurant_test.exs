defmodule Inmana.RestaurantTest do
  use Inmana.DataCase, async: true

  alias Ecto.Changeset
  alias Inmana.Restaurant

  describe "changeset/1" do
    test "when all params are valid, returns a valid changeset" do
      params = %{name: "Siri Cascudo", email: "siri@cascudo.com"}

      response = Restaurant.changeset(params)

      assert %Changeset{changes: %{email: "siri@cascudo.com", name: "Siri Cascudo"}, valid?: true} = response
    end

    # Testando erros
    test "When there are invalid params, returns an invalid changeset" do
      params = %{name: "S", email: "siricascudocom"}

      expected_response = %{email: ["has invalid format"], name: ["should be at least 2 character(s)"]}

      response = Restaurant.changeset(params)

      assert %Changeset{valid?: false} = response

      assert errors_on(response) == expected_response
    end
  end
end
