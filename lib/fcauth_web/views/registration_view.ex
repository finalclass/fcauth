defmodule FCAuthWeb.RegistrationView do
  use FCAuthWeb, :view

  def render("register-result.json", %{result: result}) do
    result
  end

  def render("confirm-result.json", %{result: result}) do
    result
  end
  
end
