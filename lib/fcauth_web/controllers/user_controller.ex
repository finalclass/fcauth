defmodule FCAuthWeb.UserController do
  use FCAuthWeb, :controller
  alias FCAuth.UserEngine
  alias FCAuth.UserDataAccess

  def index(conn, _params) do
    all_confirmed = UserDataAccess.all_by_status(:confirmed)
    conn |> render("users.json", %{users: all_confirmed})
  end

  def get(conn, %{"id" => id}) do
    case UserDataAccess.get(id) do
      nil -> conn |> put_status(404) |> render("generic-result.json", %{result: %{error: :not_found}})
      user -> conn |> render("user.json", %{user: user})
    end
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
      {:error, :not_found} ->
        conn
        |> put_status(404)
        |> render("generic-result.json", %{result: %{error: :not_found}})

      _ ->
        conn
        |> render("generic-result.json", %{result: %{ok: true}})
    end
  end

  def remove_role(conn, %{"id" => userId, "role" => role}) do
    case UserEngine.remove_role(userId, role) do
      {:error, :not_found} ->
        conn
        |> put_status(404)
        |> render("generic-result.json", %{result: %{error: :not_found}})

      _ ->
        conn |> render("generic-result.json", %{result: %{ok: true}})
    end
  end
end
