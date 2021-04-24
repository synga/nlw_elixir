# aqui é o ponto de entrada da minha aplicação, pense aqui como se fosse o app.component do angular
defmodule Inmana do
  # Ter 2 "create" como alias da conflito, então crio uma facade para cada create pra poder utilizar
  # sem problemas algum
  alias Inmana.Restaurants.Create, as: RestaurantCreate
  alias Inmana.Supplies.Create, as: SupplyCreate
  alias Inmana.Supplies.Get, as: SupplyGet

  # design pattern: facade
  # Aqui crio um alias e estou delegando pra função create_restaurant o modulo Create e a função
  # Call desse modulo. É um alias. Assim consigo chamar Inmana.create_restaurant e já funciona
  defdelegate create_restaurant(params), to: RestaurantCreate, as: :call

  # Crio uma facade do create_suply, recebendo parametros, que vai ser delegado o modulo SupplyCreate
  # para a função e desse modulo pela a função call
  defdelegate create_supply(params), to: SupplyCreate, as: :call
  defdelegate get_supply(params), to: SupplyGet, as: :call
end
