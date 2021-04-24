defmodule Inmana.Supplies.Get do
  alias Inmana.{Repo, Supply}

  # Vou receber um uuid por parametro; começo a partir do supply; dou um Repo.get(), e como esse Repo
  # é um modulo separado com suas funções, o primeiro parametro é o schema que quero buscar os dados
  # e no caso é o supply, e o segundo parametro é o uuid, como o supply já está implicito, só passo id
  def call(uuid) do
    # Supply
    # |> Repo.get(uuid)
    # |> handle_get()

    # Fazendo o retorno com um case, que é como um switch case de outras linguagens; Usando pattern match
    # Faço case no Repo.get do supply com o uuid, começo pelo caso de erro/nulo, se veio ele, o que
    # falo é retornar o error; agora se veio algum valor, retorno esse valor com o status de :ok
    # Acho que a -> significa um código executado em uma linha só, tinho arrow function
    case Repo.get(Supply, uuid) do
      nil -> {:error, %{result: "Supply not found", status: :not_found}}
      supply -> {:ok, supply}
    end
  end

  # Se deu certo ele traz apenas o resultado, então mando o result
  # defp handle_get(%Supply{} = result), do: {:ok, result}
  # Se não achou ele retorna nil, então se pelo pattern match vir nil, dou um erro de not_found
  # defp handle_get(nil), do: {:error, %{result: "Supply not found", status: :not_found}}
end
