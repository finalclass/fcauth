defmodule FCAuthWeb.Router do
  use FCAuthWeb, :router

  pipeline :public do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", FCAuthWeb do
    pipe_through :public

    post "/login", LoginController, :login
    
    post "/remind-password", RemindPasswordController, :request
    get "/remind-password/change", RemindPasswordController, :change_password
    
    post "/register", RegistrationController, :register
    get "/register/confirm-email/:token", RegistrationController, :confirm
  end

  scope "/users", FCAuthWeb do
    pipe_through :public
    pipe_through :protected
    
    get "/", UserController, :list
    get "/:id", UserController, :get
    delete "/:id", UserController, :delete
    put "/:id", UserController, :update
    post "/:id", UserController, :create
  end
end
