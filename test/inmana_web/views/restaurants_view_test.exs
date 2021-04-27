# Aqui ele não passa pelo controller pra fazer o derive e pegar só o que precisa, o meu create_restaurant
# vai me retornar TUDO da criação de um restaurante
defmodule InmanaWeb.RestaurantsViewTest do
  # Para teste de view também uso o ConnCase
  # ,async: true executa todos os testes asyncronamente, PORÉM usar só com Postgre. Mais nas anotações
  use InmanaWeb.ConnCase, async: true

  # Preciso importar o Phoenix.View para expor o metodo render/3()
  import Phoenix.View

  # Crio um alias do Inmana.RestaurantView pois o render aqui não sabe de qual modulo o "create.json" pertence
  alias Inmana.Restaurant
  alias InmanaWeb.RestaurantsView

  # Quero testar o render com aridade 2
  describe "render/2" do
    # Só tenho 1 teste aqui, que é o de sucesso ao criar a view
    test "renders create.json" do
      # As params para criação do meu restaurante
      params = %{name: "Siri Cascudo", email: "siri@cascudo.com"}
      # Crio um restaurante e já por pattern match pego o status de :ok e o restaurante devolvido
      {:ok, restaurant} = Inmana.create_restaurant(params)
      # Crio minha view guardando ela em response; Passo o ResturantsView pois aqui não tem aquela ligação
      # Em que o view sabe a qual controller ele pertence; Depois passo o nome da view a ser criada; e
      # por ultimo passo os dados do restaurante; Esse render é igual ao Render no RestaurantsView
      response = render(RestaurantsView, "create.json", restaurant: restaurant)

      # Por pattern match faço o assert de que essa lista que tenho deve ser igual ao response. porém
      # Removo dados como __meta__ e supplies que não vão ser utilizados, e created_at e updated_at que
      # são dados que mudam a cada criação; O id quero verificar se ele existe, porém o valor do id não
      # importa, então deixo como inutilizado;
      # !!!Pesquisar!!! ao colocar essa lista em uma variavel me deu um erro falando que _id/0 não estava
      # definido; De alguma forma ele achou que esse _id era uma função. Por que acontece isso fora do
      # Pattern Match? É a forma correta?
      assert %{
        message: "Restaurant created!",
        restaurant: %Restaurant{
          email: "siri@cascudo.com",
          id: _id,
          name: "Siri Cascudo",
        }
      } = response
    end
  end
end
