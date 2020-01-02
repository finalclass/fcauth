defmodule FCAuthWeb.RegistrationController do
  use FCAuthWeb, :controller
  alias FCAuth.UserEngine

  def register(conn, %{"email" => email, "password" => password}) do
    case UserEngine.create(email, password) do
      {:ok, _} ->
        conn |> render("register-result.json", %{result: %{ok: true}})

      {:error, errors} ->
        conn |> render("register-result.json", %{result: %{ok: false, errors: errors}})
    end
  end

  def confirm(conn, _params) do
    conn
  end
end
