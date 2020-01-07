defmodule FCAuthWeb.UserController do
  use FCAuthWeb, :controller
  alias FCAuth.UserEngine

  def index(conn, _params) do
    conn
  end

  def get(conn, _params) do
    conn
  end

  def create(conn, _params) do
    conn
  end
  
  def update(conn, _params) do
    conn
  end

  def delete(conn, _params) do
    conn
  end

  def add_role(conn, %{"id" => userId, "role" => role}) do
    case UserEngine.add_role(userId, role) do
      nil ->
        conn
        |> put_status(500)
        |> render("add-role-result.json", %{result: %{error: :internal_server_error}})
      _ ->
        conn
        |> render("add-role-result.json", %{result: %{ok: true}})
    end
    
  end
  
end
