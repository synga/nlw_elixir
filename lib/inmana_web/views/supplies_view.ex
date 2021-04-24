defmodule InmanaWeb.SuppliesView do
  use InmanaWeb, :view

  def render("create.json", %{supply: supply}) do
    %{
      message: "Supply created!",
      supply: supply
    }
  end

  # Renderizo a view de show, como quero mostrar apenas o supply, transformo em uma função de uma linha
  # só pra ficar melhor.
  def render("show.json", %{supply: supply}), do: %{supply: supply}
end
