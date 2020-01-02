defmodule FCAuthWeb.RegistrationTest do
  use FCAuthWeb.ConnCase
  alias FCAuth.UserDataAccess

  defp example_user() do
    %{
        email: Bcrypt.gen_salt() <> "@example.com",
        password: "12345678"
    }
  end
  
  test "Register user", %{conn: conn} do
    conn = post(conn, Routes.registration_path(conn, :register), example_user())

    body = json_response(conn, 200)
    assert body["ok"] == true
  end

  test "Creates a new user in the database", %{conn: conn} do
    user = example_user()
    post(conn, Routes.registration_path(conn, :register), user)

    assert UserDataAccess.get(user.email).email == user.email
  end
end
