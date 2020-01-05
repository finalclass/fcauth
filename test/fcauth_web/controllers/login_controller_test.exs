defmodule FCAuthWeb.SessionControllerTest do
  use FCAuthWeb.ConnCase
  alias FCAuth.UserDataAccess
  alias FCAuth.UserEngine

  setup do
    UserEngine.create("test-login@example.com", "my-password")
    user = UserDataAccess.get("test-login@example.com")
    UserEngine.confirm(user.signup_token)

    on_exit(fn ->
      UserDataAccess.delete(user.email)
    end)
  end

  @tag :login
  test "failes on ivalid username+password", %{conn: conn} do
    conn =
      post(conn, Routes.session_path(conn, :login), %{
        email: "invalid@example.com",
        password: "my-password"
      })

    body = json_response(conn, 400)
    assert body["error"] == "invalid_email_or_password"
  end

  @tag :login
  test "on proper email+password return jwt token", %{conn: conn} do
    conn =
      post(conn, Routes.session_path(conn, :login), %{
        email: "test-login@example.com",
        password: "my-password"
      })

    body = json_response(conn, 200)
    assert Map.has_key?(body, "jwt")
  end
end
