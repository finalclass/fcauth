defmodule FCAuthWeb.Router do
  use FCAuthWeb, :router

  pipeline :public do
    plug :accepts, ["json"]
    
    plug FCAuthWeb.GuardianPipeline
  end

  pipeline :protected do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", FCAuthWeb do
    pipe_through :public

    post "/login", SessionController, :login

    post "/sign-up", SignupController, :register
    get "/sign-up/confirm-email/:token", SignupController, :confirm
    
    post "/remind-password", RemindPasswordController, :request
    get "/remind-password/change", RemindPasswordController, :change_password
  end

  scope "/users", FCAuthWeb do
    pipe_through :public
    pipe_through :protected

    get "/", UserController, :index
    get "/:id", UserController, :get
    post "/", UserController, :create
    put "/:id", UserController, :update
    delete "/:id", UserController, :delete
  end
end
