# Modulo responsável por enviar os emails de produtos a expirar
defmodule Inmana.Supplies.ExpirationNotification do
  # Crio alias do mailer e também do expirationemail e getbyexpiration do supplies
  alias Inmana.Mailer
  alias Inmana.Supplies.{ExpirationEmail, GetByExpiration}

  # Aqui é feito sem usar streams e sem usar tasks e processos
  # def send do
  #   # Pego os dados de itens que estão a expirar
  #   data = GetByExpiration.call()

  #   # Uso um enum que para cada item, como o data vai ser uma tupla, pego o to_email (que vai ser o email),
  #   # e o supplies (a lista de itens); e executo a função anonima
  #   Enum.each(data, fn {to_email, supplies} ->
  #     # Aqui começo o pipe a partir do email; Passo ele para a função create do ExpirationEmail junto do
  #     # supplies; Essa função monta o email e me devolve, que passo pro deliver_later enviar
  #     to_email
  #     |> ExpirationEmail.create(supplies)
  #     |> Mailer.deliver_later!()
  #   end)
  # end

  # No modo novo, utilizando tasks e processos para envio de emails paralelamente, utilizando dos nucleos
  # do processador para ter processos diferentes onde cada um executa junto de outro (paralelamente, como
  # disse); No modo comentado acima cada e-mail é enviado de uma vez, o que pode ser ruim dependendo da
  # quantidade de itens disponiveis; Já nessa nova forma, cada envio vai para um processo próprio e é
  # enviado independente do outro processo
  def send do
    # Pego os dados de produtos a expirar
    data = GetByExpiration.call()

    # Começo o pipe a partir do data; passo os dados para uma Task.async_stream pra criar uma lista de
    # processos de Emails a serem enviados; Depois passo essa lista de processos pro Stream.run(), que
    # por sua vez, asincronamente e paralelamente, vai enviar os emails, deixando cada um na sua thread
    # executando assim que terminarem, e depois matando o processo, abrindo espaço para outro.
    data
    |> Task.async_stream(fn {to_email, supplies} -> send_email(to_email, supplies) end)
    |> Stream.run()
  end

  # Função privada para envio do email; foi criada pois estava com muita coisa na função de send.
  # Dessa forma ficou mais legivel; Só recebe o email e supplies e faz todo o caminho para envio de email
  defp send_email(to_email, supplies) do
    to_email
    |> ExpirationEmail.create(supplies)
    |> Mailer.deliver_later!()
  end
end
