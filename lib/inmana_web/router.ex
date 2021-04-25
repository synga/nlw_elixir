defmodule InmanaWeb.Router do
  use InmanaWeb, :router

  pipeline :api do
    # Pipeline de api Aceita apenas json
    plug :accepts, ["json"]
  end

  # Basicamente endpoint /api, dentro crio meus gets de rota. Posso ter rotas com o resto do CRUD?
  # PARA VER ROTAS SÓ USAR O COMANDO mix phx.server, é bom pra ver quais rotas tenho criadas e nome de
  # funções que dizem respeito a elas nos controllers
  scope "/api", InmanaWeb do
    # Define que estamos utilizando o pipeline :api
    pipe_through :api

    # Quando chamar /api, ativar o WelcomeController chamando a função index
    get "/", WelcomeController, :index

    # Cria uma rota para /restaurants, que o controller é o RestaurantsController, e que ao chamar essa
    # rota vai ativar o metodo create
    post "/restaurants", RestaurantsController, :create

    # Da pra criar rotas de um jeito fácil usando o resources, ele cria todas as rotas possiveis para
    # um schema, e você pode passar só as que quer também ao invés de fazer o que está abaixo;
    # post "/supplies", SuppliesController, :create
    # get "/supplies/:id", SuppliesController, :show
    # Ele cria as rotas com nomes pré-definidos, então minhas funções devem seguir esses nomes, é preciso

    # Com esse resources, crio a rota de supplies referente ao SuppliesController e passo que só
    # quero as rotas de create e de show
    resources "/supplies", SuppliesController, only: [:create, :show]
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

  # Uma rota para em ambiente de dev ver os emails que estão sendo enviados, depois de enviar basta
  # dar um F5 na rota
  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
