defmodule FCAuthWeb.Router do
  use FCAuthWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FCAuthWeb do
    pipe_through :api
  end
end
