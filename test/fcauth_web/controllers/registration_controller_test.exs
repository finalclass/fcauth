defmodule FCAuthWeb.RegistrationTest do
  use FCAuthWeb.ConnCase
  alias FCAuth.UserDataAccess
  alias FCAuth.MailerMock

  setup do
    FCAuth.MailerMock.start_link()
    :ok
  end
  
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

  test "Sends email to user", %{conn: conn} do
    user = example_user()
    MailerMock.clear_invocations()
    post(conn, Routes.registration_path(conn, :register), user)
    mail_params = MailerMock.pop_invocation()
    assert mail_params != nil
    assert mail_params.to == [user.email]
  end

  test "Email conatins confiration URL", %{conn: conn} do
    user = example_user()
    MailerMock.clear_invocations()
    post(conn, Routes.registration_path(conn, :register), user)
    mail_params = MailerMock.pop_invocation()

    assert mail_params != nil
    assert String.contains?(mail_params.html, "/sign-up/confirm-email")
  end
end
