defmodule InmanaWeb.SuppliesController do
  use InmanaWeb, :controller

  alias Inmana.Supply
  alias InmanaWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %Supply{} = supply} <- Inmana.create_supply(params) do
      conn
      |> put_status(:created)
      |> render("create.json", supply: supply)
    end
  end

  # Aqui vai ser a ação de show do controller, acessada atráves da rota /show/:id;
  # Aqui como já sabe que vai receber um ID dentro dos parametros, como vai ser um map contendo o id,
  # Já pega apenas o id via pattern match e chama de uuid. Todo o restante é igual acima, sem problemas
  def show(conn, %{"id" => uuid}) do
    with {:ok, %Supply{} = supply} <- Inmana.get_supply(uuid) do
      conn
      |> put_status(:ok)
      |> render("show.json", supply: supply)
    end
  end

end
