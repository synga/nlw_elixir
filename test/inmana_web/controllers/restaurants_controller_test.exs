defmodule InmanaWeb.RestaurantsControllerTest do
  # ConnCase é utilizado para testar controllers
  # ,async: true executa todos os testes asyncronamente, PORÉM usar só com Postgre. Mais nas anotações
  use InmanaWeb.ConnCase, async: true

  describe "create/2" do
    # Na frente do titulo do teste, pega a conexão mockada criada pelo conncase
    test "when all params are valid, creates the user", %{conn: conn} do
      params = %{name: "Siri Cascudo", email: "siri@cascudo.com"}

      # Aqui além de pegar a resposta também é feito um teste; então o que faço, a minha response eu começo
      # um pipe com a minha conexão; Depois preciso passar qual metodo estou chamando usando uma função
      # que fica exposta pelo ConnCase, no caso o post, que como primeiro argumento pelo pipe vai ter o conn
      # e por segundo preciso do path, ai uso o Routes para criar esse path; Esse restaurants_path é uma
      # função criada automaticamente? Enfim, passo a conexão, o metodo chamado e os parametros e ele me cria
      # um path; Depois o proprio json_response já é um assert, e ele vai esperar receber um json com o
      # status de created
      response =
        conn
        |> post(Routes.restaurants_path(conn, :create, params))
        |> json_response(:created)

      # Aqui faço mais um assert de que a resposta vai vir igual o map abaixo; Porém o ID é gerado pelo
      # Ecto automaticamente, então eu comento o resultado do id e ainda assim o pattern match vem certo
      # pois os campos estão corretos
      assert %{
               "message" => "Restaurant created!",
               "restaurant" => %{
                 "email" => "siri@cascudo.com",
                 "id" => _id,
                 "name" => "Siri Cascudo"
               }
             } = response
    end

    # Testando o erro; É parecido com o feito acima, porém o expected_response é criado com um erro e o
    # json_response espera um :bad_request como status da requisição; Ah, os params são diferentes, claro
    test "when there are invalid properties, returns an error", %{conn: conn} do
      params = %{name: "S", email: "siricascudo.com"}

      response =
        conn
        |> post(Routes.restaurants_path(conn, :create, params))
        |> json_response(:bad_request)

      # Jogar essa lista que uso em uma variavel como expected_response da um warning de que não está
      # sendo utilizado, então removi essa variavel e coloquei direto aqui;
      assert %{
        "message" => %{
          "email" => ["has invalid format"],
          "name" => ["should be at least 2 character(s)"]
        }
      } = response
    end
  end
end
