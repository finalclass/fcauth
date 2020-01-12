defmodule FCAuthWeb.Router do
  use FCAuthWeb, :router

  pipeline :public do
    plug :accepts, ["json"]
    
    plug FCAuthWeb.GuardianPipeline
  end

  pipeline :protected do
    plug Guardian.Plug.EnsureAuthenticated
    plug :ensure_fcauth_admin
  end

  defp ensure_fcauth_admin(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    fcauth_roles = Map.get(user.roles, :fcauth, [])
    if fcauth_roles |> Enum.member?("admin") do
      conn
    else
      conn
      |> Plug.Conn.put_status(401)
      |> Phoenix.Controller.json(%{error: :unothorized})
      |> halt()
    end
  end

  scope "/", FCAuthWeb do
    pipe_through :public

    post "/:app/login", SessionController, :login

    post "/sign-up", SignupController, :register
    get "/sign-up/confirm-email/:token", SignupController, :confirm
    
    # post "/remind-password", RemindPasswordController, :request
    # get "/remind-password/change", RemindPasswordController, :change_password
  end

  scope "/users", FCAuthWeb do
    pipe_through :public
    pipe_through :protected

    put "/:id/roles/:app/:role", UserController, :add_role
    delete "/:id/roles/:app/:role", UserController, :remove_role
    get "/", UserController, :index
    get "/:id", UserController, :get
  #   post "/", UserController, :create
  #   put "/:id", UserController, :update
  #   delete "/:id", UserController, :delete
  end
end
