defmodule FCAuthWeb.RegistrationView do
  use FCAuthWeb, :view

  def render("confirm.html", %{confirm_url: confirm_url, email: email}) do
    """
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8"/>
    <title>Potwierdź email</title>
  </head>
  <body>
    Witaj #{email}!
    <p>
      Twoje konto zostało utworzone. Jest jednak obecnie nieaktywne. Aby aktywować konto kliklij w poniższy link:
    </p>

    <a href="#{confirm_url}">#{confirm_url}</a>
  </body>
</html>
"""
  end
  
  def render("register-result.json", %{result: result}) do
    result
  end

  def render("confirm-result.json", %{result: result}) do
    result
  end
  
end
