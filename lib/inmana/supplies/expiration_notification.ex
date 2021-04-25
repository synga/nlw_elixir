# Modulo responsável por enviar os emails de produtos a expirar
defmodule Inmana.Supplies.ExpirationNotification do
  # Crio alias do mailer e também do expirationemail e getbyexpiration do supplies
  alias Inmana.Mailer
  alias Inmana.Supplies.{ExpirationEmail, GetByExpiration}

  def send do
    # Pego os dados de itens que estão a expirar
    data = GetByExpiration.call()

    # Uso um enum que para cada item, como o data vai ser uma tupla, pego o to_email (que vai ser o email),
    # e o supplies (a lista de itens); e executo a função anonima
    Enum.each(data, fn {to_email, supplies} ->
      # Aqui começo o pipe a partir do email; Passo ele para a função create do ExpirationEmail junto do
      # supplies; Essa função monta o email e me devolve, que passo pro deliver_later enviar
      to_email
      |> ExpirationEmail.create(supplies)
      |> Mailer.deliver_later!()
    end)
  end
end
