defmodule FCAuthWeb.UserControllerTest do
  use FCAuthWeb.ConnCase
  alias FCAuth.UserDataAccess
  alias FCAuth.User

  @email "test-roles@example.com"
  @password "my-password"

  @emailAdmin "test-admin@example.com"
  @passwordAdmin "admin-pass"

  def create_and_login(conn, email, pass, roles \\ []) do
    UserDataAccess.save(%User{
      email: email,
      password_hash: Bcrypt.hash_pwd_salt(pass),
      roles: roles,
      status: "confirmed"
    })

    loginResult =
      post(conn, Routes.session_path(conn, :login), %{
        email: email,
        password: pass
      })

    %{"jwt" => jwt} = json_response(loginResult, 200)
    jwt
  end

  setup do
    on_exit(fn ->
      UserDataAccess.delete(@email)
      UserDataAccess.delete(@emailAdmin)
    end)
  end

  setup %{conn: conn} do
    {:ok,
     admin_jwt: conn |> create_and_login(@emailAdmin, @passwordAdmin, ["admin"]),
     logged_jwt: conn |> create_and_login(@email, @password)}
  end

  describe "adding roles" do
    @tag :user
    test "only admin is allowed to do that", %{conn: conn, logged_jwt: jwt} do
      conn = conn
      |> Plug.Conn.put_req_header("authorization", "Bearer #{jwt}")
      |> put(Routes.user_path(conn, :add_role, @email, "test"))

      assert conn.status == 401
    end
    
    test "can add role", %{conn: conn, admin_jwt: jwt} do
      conn = conn
      |> Plug.Conn.put_req_header("authorization", "Bearer #{jwt}")
      |> put(Routes.user_path(conn, :add_role, @email, "test"))
      
      assert conn.status == 200
      user = UserDataAccess.get(@email)
      assert user.roles == ["test"]
    end

    
  end
end
