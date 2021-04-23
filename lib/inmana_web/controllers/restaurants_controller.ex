defmodule InmanaWeb.RestaurantsController do
  use InmanaWeb, :controller

  alias Inmana.Restaurant

  # esse as da um apelido ao modulo, cria um facade e posso usar esse apelido pra acessar as funções
  # alias Inmana.Restaurants.Create, as: RestaurantCreate

  alias InmanaWeb.FallbackController

  # Para lidar com erros
  action_fallback FallbackController

  # O WITH FAZ UM PATTERN MATCH DO TIPO, SE OS DADOS NA FRENTE DELE FORAM RETORNADOS DE CREATE.CALL
  # ENTÃO EXECUTO A AÇÃO
  #
  # Se cai no erro ele sozinho sabe pegar o action_fallback? Ele sabe que é pra pegar o fallbackcontroller?
  # Como isso acontece?
  # falar do create.json
  def create(conn, params) do
    with {:ok, %Restaurant{} = restaurant} <- Inmana.create_restaurant(params) do
      conn
      |> put_status(:created)
      |> render("create.json", restaurant: restaurant)
    end
  end

end
