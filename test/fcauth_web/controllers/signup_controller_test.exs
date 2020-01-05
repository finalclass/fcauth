defmodule FCAuthWeb.SignupTest do
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

  describe "Sign Up" do
    test "Registers user", %{conn: conn} do
      conn = post(conn, Routes.signup_path(conn, :register), example_user())

      body = json_response(conn, 200)
      assert body["ok"] == true
    end

    test "Creates a new user in the database", %{conn: conn} do
      user = example_user()
      post(conn, Routes.signup_path(conn, :register), user)
      
      assert UserDataAccess.get(user.email).email == user.email
    end

    test "Sends email to user", %{conn: conn} do
      user = example_user()
      MailerMock.clear_invocations()
      post(conn, Routes.signup_path(conn, :register), user)
      mail_params = MailerMock.pop_invocation()
      assert mail_params != nil
      assert mail_params.to == [user.email]
    end

    test "Email conatins confiration URL", %{conn: conn} do
      user = example_user()
      MailerMock.clear_invocations()
      post(conn, Routes.signup_path(conn, :register), user)
      mail_params = MailerMock.pop_invocation()

      assert mail_params != nil
      assert String.contains?(mail_params.html, "/sign-up/confirm-email")
    end
  end


  describe "Confirm" do

    @tag :confirm
    test "On invalid tokens don't throw (prevent brute force attacks)", %{conn: conn} do
      conn = get(conn, Routes.signup_path(conn, :confirm, "INVALID"))
      assert conn.status == 200
      body = json_response(conn, 200)
      assert body["ok"] == true
    end

    @tag :confirm
    test "Confirm checks if token is not expired", %{conn: conn} do
      user_data = example_user()
      conn = post(conn, Routes.signup_path(conn, :register), user_data)
      user = UserDataAccess.get(user_data.email) |> Map.put(:signup_token_generated_at, 0)
      
      UserDataAccess.save(user)
      
      conn = get(conn, Routes.signup_path(conn, :confirm, user.signup_token))

      assert conn.status == 403
      body = json_response(conn, 200)
      assert body["error"] == "token expired"
    end
  end
  
end
