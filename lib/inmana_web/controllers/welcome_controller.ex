# Define o modulo WelcomeController do InmanaWeb. note a diferença entre o web e api
defmodule InmanaWeb.WelcomeController do
  # Definindo que o module deve ser um controller. Quase um implements?
  use InmanaWeb, :controller

  # Crio um alias do Inmana.Welcomer para poder chamar apenas de Welcomer
  alias Inmana.Welcomer

  # Define o index da rota, algo assim, a função principal do controller
  # conn é a connexão, é um map; Params são os parametros passados na URL
  # pega o params, passa pra função de welcome criada no Welcomer
  # Depois o resultado passa para o handle_response que vai lidar com a resposta
  # da função e dar o resultado pro usuario.
  def index(conn, params) do
    params
    |> Welcomer.welcome()
    |> handle_response(conn)
  end

  # Aqui usa o pattern match para criar um if; Se veio com uma tupla de :ok e a mensagem
  # e a conexão, entra aqui.
  # Faz um pipe pegando a conexão, chama a função put_status com o status de :ok, depois o json com retorno
  # não sei de onde vem o put_status e o json, deve ser algo do phoenix no escopo global
  defp handle_response({:ok, message}, conn) do
    conn |> put_status(:ok) |> json(%{message: message})
  end

  # mesma coisa que acima, porém recebendo um error eu retorno um bad_request
  defp handle_response({:error, message}, conn) do
    conn |> put_status(:bad_request) |> json(%{message: message})
  end

  # TENHO UMA FORMA REDUZIDA DE FAZER A FUNCIONALIDADE ACIMA, VOU ESCREVER PORÉM COMENTADO POR CAUSA DO LINT
  # A IDEIA É TER UMA FUNÇÃO QUE FAZ A PARTE DE RETORNAR A RESPOSTA, JÁ QUE O CÓDIGO SE REPETE
  # NAS DUAS FUNÇÕES DE handle_response, E É UMA FORMA MAIS CURTA TAMBÉM:

  # AQUI O QUE FAÇO É CHAMAR A FUNÇÃO return_response EM UMA LINHA SÓ FAZENDO ASSIM:
  # DEFINO A FUNÇÃO QUE VAI SER ESCOLHIDA/CONTROLADA PELO PATTERN MATCHING
  # COLOCO UMA VIRGULA PRA SEPARAR, COLOCO do: COM DOIS PONTOS INDICANDO O QUE ELE DEVE FAZER
  # NO CASO CHAMAR A FUNÇÃO DE return_response PASSANDO OS DADOS NECESSÁRIOS
  # defp handle_response_short({:ok, message}, conn), do: return_response(conn, message, :ok)
  # defp handle_response_short({:error, message}, conn), do: return_response(conn, message, :bad_request)
  # A FUNÇÃO AQUI NÃO FAZ NADA DEMAIS, RECEBE OS ARGUMENTOS, PASSA PELA CONN, COLOCA O STATUS E RETORNA O JSON
  # defp return_response(conn, message, status) do
  #   conn |> put_status(status) |> json(%{message: message})
  # end
end
