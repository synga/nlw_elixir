defmodule Inmana.RestaurantTest do
  # Aqui preciso usar o Inmana.DataCase pois ele tem tudo que precisamos para teste de changeset
  # Falo mais nas anotações
  # ,async: true executa todos os testes asyncronamente, PORÉM usar só com Postgre. Mais nas anotações
  use Inmana.DataCase, async: true

  alias Ecto.Changeset
  alias Inmana.Restaurant

  describe "changeset/1" do
    test "when all params are valid, returns a valid changeset" do
      params = %{name: "Siri Cascudo", email: "siri@cascudo.com"}

      response = Restaurant.changeset(params)

      # Aqui vou fazer o teste pegando por pattern match e dando um assert nisso;
      # Primeiro fez falhar para ver qual era o resultado; viu que o resultado era um changeset com os
      # valores abaixo; então criou um alias de Changeset e criou um changeset igual ao retorno dado
      # pela função no response, visto que é um retorno valido; Depois, por pattern match, como ele retorna
      # um true se estiver tudo certo, vou dar um assert que os dados do changeset são iguais ao response
      assert %Changeset{changes: %{email: "siri@cascudo.com", name: "Siri Cascudo"}, valid?: true} = response
    end

    # Testando erros
    test "When there are invalid params, returns an invalid changeset" do
      params = %{name: "S", email: "siricascudocom"}
      # Crio uma resposta que espero do erro, então baseado no params acima e nas validações existentes
      # Esses são os erros que espero receber no response
      expected_response = %{email: ["has invalid format"], name: ["should be at least 2 character(s)"]}

      # Chamo a função com meu params para pegar o resultado
      response = Restaurant.changeset(params)

      # aqui só o %Changeset{valid?: false} = response já funciona para verificar se o retorno é valido
      # ou não, o que esperamos que não seja, por isso verifico apenas se o changeset retornado tem um
      # valid setado em false
      assert %Changeset{valid?: false} = response

      # Aqui estou verificando usando a função errors_on que está disponivel no DataCase - que é basicamente
      # a função de traverse_errors que foi criada no meu arquivo de errors - se os errors retornados no
      # meu response são os mesmos que tenho no expected_response, e aqui como é só uma lista, ai sim
      # uso a comparação de igualdade e não pattern match, tentei chamar como pattern match para teste
      # e ele falhou;
      # Então a errors_on vai pegar do meu changeset retornado apenas os errors
      assert errors_on(response) == expected_response
    end
  end
end
