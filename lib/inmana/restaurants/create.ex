defmodule Inmana.Restaurants.Create do

  # Criando multiplos alias vindos de um mesmo modulo
  alias Inmana.{Repo, Restaurant}

  # Já que o contexto é o de criação, por isso Create no nome, então aqui crio uma função de call()
  # que vai ser responsável por chamar a ação de criar; Se atentar também ao contexto/escopo, pois
  # estou dentro de restaurants, no plural;
  def call(params) do
    params
    |> Restaurant.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  # VIA PATTERN MATCH VOU LIDAR COM O RESTORNO DA INSERÇÃO FEITA PELO REPO NO DB
  # PRIMEIRO SE VEIO COM STATUS DE OK E UM STRUCT DE RESTAURANT, ATRIBUO O STRUCT A VARIAVEL RESULT
  # E SÓ RETORNO ESSE RESULT
  # SE VEIO UM ERRO, PEGO O ERRO E O RESULTADO E RETORNO EM UMA TUPLA CONTENDO O ERRO, E UM MAP COM O
  # RESULT E O STATUS
  # Aqui havia feito errado, o result tem que ser o atom de ok e o struct, não só o struct
  defp handle_insert({:ok, %Restaurant{}} = result), do: result

  defp handle_insert({:error, result}), do: {:error, %{result: result, status: :bad_request}}
end
