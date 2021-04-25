# Aqui define o modulo de mailer para deixar disponivel para a aplicação o Mailer do Bamboo
defmodule Inmana.Mailer do
  # Pesquisar o que é esse otp_app, mas o valor do inmana tem que ser minusculo
  use Bamboo.Mailer, otp_app: :inmana
end
