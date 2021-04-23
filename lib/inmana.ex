# aqui é o ponto de entrada da minha aplicação, pense aqui como se fosse o app.component do angular
defmodule Inmana do
  alias Inmana.Restaurants.Create

  # design pattern: facade
  # Aqui crio um alias e estou delegando pra função create_restaurant o modulo Create e a função
  # Call desse modulo. É um alias. Assim consigo chamar Inmana.create_restaurant e já funciona
  defdelegate create_restaurant(params), to: Create, as: :call
end
