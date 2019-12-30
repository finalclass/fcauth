defmodule FCAuthWeb.RemindPasswordView do
  use FCAuthWeb, :view

  def render("request-result.json", %{result: result}) do
    result
  end

  def render("change-password-result.json", %{result: result}) do
    result
  end
  
end
