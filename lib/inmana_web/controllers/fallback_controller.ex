defmodule InmanaWeb.FallbackController do
  use InmanaWeb, :controller

  alias InmanaWeb.ErrorView

  # Tudo que enviar pro FallbackController cai no call
  # como a view de error não segue o mesmo nome do Fallbackcontroller, preciso passar pelo put_view
  # que eu insiro a view que quero no escopo dessa função/modulo pra ser utilizado.
  def call(conn, {:error, %{result: result, status: status}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", result: result)
  end
end
