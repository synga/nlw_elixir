defmodule Inmana.Supply do
  use Ecto.Schema
  import Ecto.Changeset
  alias Inmana.Restaurant

  @primary_key {:id, :binary_id, autogenerate: true}

  # Definindo que o id do restaurante pai desse supply é um binary_id. Se não da erro pois ele vai
  # esperar um inteiro
  @foreign_key_type :binary_id

  @required_params [:description, :expiration_date, :responsible, :restaurant_id]
  # passo pro encoder de retorno os params requeridos concatenando o id para a lista
  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  schema "supplies" do
    field :description, :string
    field :expiration_date, :date
    field :responsible, :string

    # Um suprimento pertence ao restaurantem aqui faço o relacionamento de filho pra pai
    belongs_to :restaurant, Restaurant

    timestamps()
  end

  # Explicação sobre o que é feito aqui está em restaurant.ex
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:description, min: 3)
    |> validate_length(:responsible, min: 3)
  end
end
