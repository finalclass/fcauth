defmodule FCAuthWeb.SessionController do
  use FCAuthWeb, :controller
  alias FCAuth.UserEngine

  def login(conn, %{"app" => app, "email" => email, "password" => password}) do
    case UserEngine.login(app, email, password) do
      {:ok, jwt} ->
        conn |> render("login-response.json", %{result: %{ok: true, jwt: jwt}})
      {:error, error} ->
        conn
        |> put_status(400)
        |> render("login-response.json", %{result: %{error: error}})
    end
  end
end
