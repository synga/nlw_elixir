defmodule Inmana.Repo.Migrations.CreateRestaurantsTable do
  use Ecto.Migration

  def change do
    create table(:restaurants) do
      add :email, :string
      add :name, :string # cria um campo nome do tipo string

      timestamps() # cria as colunas inserted_at e updated_at
    end

    create unique_index(:restaurants, [:email]) # cria um index para que restaurants não criem
    # conta com o mesmo migration
  end
end
