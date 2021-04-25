# Modulo que vai criar um email, mas não enviar ainda, só retorna o email criado na estrutura do Bamboo
# Para ser enviado pelo deliver_later do Mailer
defmodule Inmana.Supplies.ExpirationEmail do
  # Importo o Email para ter ele presente no contexto desse modulo
  import Bamboo.Email

  # Alias do supply para ser usado no pattern match
  alias Inmana.Supply

  # Função responsável por criar o email a partir do email do usuario e os supplies
  def create(to_email, supplies) do
    new_email(
      to: to_email,
      from: "app@inmana.com.br",
      subject: "Supplies that are about to expire!",
      text_body: email_text(supplies)
    )
  end

  # Função privada que vai iterar os supplies e criar um texto concatenando os supplies que vão vencer
  defp email_text(supplies) do
    # Cria o texto inicial do qual a partir dele vai concatenar o restante
    initial_text = "-------- Supplies that are about to expire: --------\n"

    # Usa um reduce no Supplies, que a partir do texto inicial, vai executar uma função anonima para
    # concatenar uma string; Essa função anonima recebe o supply que está iterando e o texto inicial e/ou
    # concatenado; Que concatena o texto com o retorno da função supply_string
    Enum.reduce(supplies, initial_text, fn supply, text -> text <> supply_string(supply) end)
  end

  # Função privada que vai receber um Supply, checar via pattern match que é esse Supply, que até criamos
  # Um alias para usar no pattern match; E dessa tupla de supply pegamos apenas alguns dados.
  defp supply_string(%Supply{
         description: description,
         expiration_date: expiration_date,
         responsible: responsible
       }) do
    "Description: #{description}, Expiration Date: #{expiration_date}, Responsible: #{responsible}\n"
  end
end
