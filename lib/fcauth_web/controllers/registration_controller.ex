defmodule FCAuthWeb.RegistrationController do
  use FCAuthWeb, :controller
  alias FCAuth.UserEngine

  @mailer Application.get_env(:fcauth, :mailer)

  def register(conn, %{"email" => email, "password" => password}) do
    case UserEngine.create(email, password) do
      {:error, errors} ->
        conn |> render("register-result.json", %{result: %{ok: false, errors: errors}})

      {:ok, user} ->
        confirm_url = FCAuthWeb.Router.Helpers.url(conn) <> Routes.registration_path(conn, :confirm, user.signup_token)
        @mailer.deliver(%{
          subject: "Potwierdź rejestracje",
          to: [email],
          html:
            FCAuthWeb.RegistrationView.render(
              "confirm.html",
              %{confirm_url: confirm_url, email: email}
            )
        })

        conn |> render("register-result.json", %{result: %{ok: true}})
    end
  end

  def confirm(conn, _params) do
    conn
  end
end
