defmodule FCAuthWeb.UserView do
  use FCAuthWeb, :view

  def render("users.json", %{users: users}) do
    render_many(users, __MODULE__, "user.json")
  end

  def render("user.json", %{user: user}) do
    user
  end

  def render("delete-result.json", %{result: result}) do
    result
  end

end
