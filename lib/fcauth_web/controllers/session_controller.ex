defmodule FCAuthWeb.SessionController do
  use FCAuthWeb, :controller

  def login(conn, _params) do
    conn |> render("login-response.json", %{result: %{ok: true}})
  end
end
