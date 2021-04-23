defmodule InmanaWeb.Router do
  use InmanaWeb, :router

  pipeline :api do
    # Pipeline de api Aceita apenas json
    plug :accepts, ["json"]
  end

  # Basicamente endpoint /api, dentro crio meus gets de rota. Posso ter rotas com o resto do CRUD?
  scope "/api", InmanaWeb do
    # Define que estamos utilizando o pipeline :api
    pipe_through :api

    # Quando chamar /api, ativar o WelcomeController chamando a função index
    get "/", WelcomeController, :index

    # Cria uma rota para /restaurants, que o controller é o RestaurantsController, e que ao chamar essa
    # rota vai ativar o metodo create
    post "/restaurants", RestaurantsController, :create
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: InmanaWeb.Telemetry
    end
  end
end
