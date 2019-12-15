defmodule FcauthWeb.Router do
  use FcauthWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FcauthWeb do
    pipe_through :api
  end
end
