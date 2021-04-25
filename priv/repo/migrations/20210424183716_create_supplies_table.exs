defmodule Inmana.Repo.Migrations.CreateSuppliesTable do
  use Ecto.Migration

  def change do
    create table(:supplies) do
      add :description, :string
      add :expiration_date, :date
      add :responsible, :string
      # Aqui crio a referencia ao restaurante, pois um produto pertence a um restaurante
      add :restaurant_id, references(:restaurants, type: :binary_id)

      timestamps()
    end
  end
end
