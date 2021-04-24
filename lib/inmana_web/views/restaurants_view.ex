# Views tem que ser InmanaWeb, havia colocado apenas inmana
defmodule InmanaWeb.RestaurantsView do
  use InmanaWeb, :view

  # crio uma metodo render que pelo pattern match vai saber que recebendo um create.json e um map com um
  # restaurante, ele deve renderizar um map com uma mensagem e o restaurante. Porém por si só, como esse
  # restaurant é uma struct, o Jason não sabe renderizar direito; com isso no meu restaurant.ex no inmana
  # eu preciso criar o @derive pra saber o que ele deve encodar e ser renderizado
  def render("create.json", %{restaurant: restaurant}) do
    %{
      message: "Restaurant created!",
      restaurant: restaurant
    }
  end
end
