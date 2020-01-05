defmodule FCAuthWeb.SessionView do
  use FCAuthWeb, :view

  def render("login-response.json", %{result: result}) do
    result
  end
  
end
