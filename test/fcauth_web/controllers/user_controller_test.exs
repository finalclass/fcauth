defmodule FCAuthWeb.UserControllerTest do
  use FCAuthWeb.ConnCase
  alias FCAuth.UserDataAccess
  alias FCAuth.User

  @email "test-roles@example.com"
  @password "my-password"

  @email_admin "test-admin@example.com"
  @password_admin "admin-pass"

  def create_and_login(conn, email, pass, roles \\ %{}) do
    UserDataAccess.save(%User{
      email: email,
      password_hash: Bcrypt.hash_pwd_salt(pass),
      roles: roles,
      status: :confirmed
    })

    loginResult =
      post(conn, Routes.session_path(conn, :login, "fcauth"), %{
        email: email,
        password: pass
      })

    %{"jwt" => jwt} = json_response(loginResult, 200)
    jwt
  end

  setup do
    on_exit(fn ->
      UserDataAccess.delete(@email)
      UserDataAccess.delete(@email_admin)
    end)
  end

  setup %{conn: conn} do
    {:ok,
     admin_jwt: conn |> create_and_login(@email_admin, @password_admin, %{fcauth: ["admin"]}),
     logged_jwt: conn |> create_and_login(@email, @password)}
  end

  describe "adding roles" do
    @tag :user
    test "only admin is allowed to do that", %{conn: conn, logged_jwt: jwt} do
      conn =
        conn
        |> Plug.Conn.put_req_header("authorization", "Bearer #{jwt}")
        |> put(Routes.user_path(conn, :add_role, @email, "fcauth", "test"))

      assert conn.status == 401
    end

    @tag :user
    test "can add role", %{conn: conn, admin_jwt: jwt} do
      conn =
        conn
        |> Plug.Conn.put_req_header("authorization", "Bearer #{jwt}")
        |> put(Routes.user_path(conn, :add_role, @email, "fcauth", "test"))

      assert conn.status == 200
      user = UserDataAccess.get(@email)
      assert user.roles == %{fcauth: ["test"]}
    end
  end

  describe "removing roles" do
    def delete_role(%{conn: conn, admin_jwt: jwt}, email, app, role) do
      conn
      |> Plug.Conn.put_req_header("authorization", "Bearer #{jwt}")
      |> delete(Routes.user_path(conn, :remove_role, email, app, role))
    end

    @tag :user
    test "on missing user give 404", ctx do
      assert delete_role(ctx, "MISSING_USER_EMAIL", "fcauth", "test").status == 404
    end

    @tag :user
    test "if no role exists, don't panic", ctx do
      assert delete_role(ctx, @email, "fcauth", "test").status == 200
    end

    @tag :user
    test "removes the role", ctx do
      assert delete_role(ctx, @email_admin, "fcauth", "admin").status == 200
      assert UserDataAccess.get(@email_admin).roles == %{}
    end
  end

  describe "get all users" do
    def get_all(%{conn: conn, admin_jwt: jwt}) do
      conn
      |> Plug.Conn.put_req_header("authorization", "Bearer #{jwt}")
      |> get(Routes.user_path(conn, :index))
    end

    @tag :user
    test "simply get all", ctx do
      conn = get_all(ctx)
      users = json_response(conn, 200)
      assert Enum.find(users, &(&1["email"] == @email_admin)) != nil
    end

    @tag :user
    test "only get users that confirmed their email", ctx do
      UserDataAccess.save(%User{email: "not-confirmed", status: :created})
      conn = get_all(ctx)
      users = json_response(conn, 200)
      assert Enum.find(users, &(&1["email"] == "not-confirmed")) == nil
    end
  end

  describe "get" do
    def get_user(%{conn: conn, admin_jwt: jwt}, email) do
      conn
      |> Plug.Conn.put_req_header("authorization", "Bearer #{jwt}")
      |> get(Routes.user_path(conn, :get, email))
    end

    @tag :user
    test "gets a user", ctx do
      conn = get_user(ctx, @email)
      user = json_response(conn, 200)
      assert user["email"] == @email
    end

    @tag :user
    test "on missing user get 404", ctx do
      assert get_user(ctx, "MISSING").status == 404
    end
  end

end
