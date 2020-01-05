defmodule FCAuthWeb.SignupController do
  use FCAuthWeb, :controller
  alias FCAuth.UserEngine

  @mailer Application.get_env(:fcauth, :mailer)

  def register(conn, %{"email" => email, "password" => password}) do
    case UserEngine.create(email, password) do
      {:error, errors} ->
        conn |> render("register-result.json", %{result: %{ok: false, errors: errors}})

      {:ok, user} ->
        confirm_url = FCAuthWeb.Router.Helpers.url(conn) <> Routes.signup_path(conn, :confirm, user.signup_token)
        {:ok, _message} = @mailer.deliver(%{
          subject: "Potwierdź rejestracje",
          to: [email],
          html:
            FCAuthWeb.SignupView.render(
              "confirm.html",
              %{confirm_url: confirm_url, email: email}
            )
        })
        
        conn |> render("register-result.json", %{result: %{ok: true}})
    end
  end

  def confirm(conn, %{"token" => token}) do
    case UserEngine.confirm(token) do
      :ok ->
        conn |> render("confirm-result.json", %{result: %{ok: true}})
      {:error, :token_does_not_exists } ->
        conn |> render("confirm-result.json", %{result: %{ok: true}})
      {:error, :token_expired} ->
        conn
        |> put_status(403)
        |> render("confirm-result.json", %{result: %{error: "token_expired"}})
      {:error, :user_already_confirmed} ->
        conn
        |> put_status(400)
        |> render("confirm-result.json", %{result: %{error: "user_already_confirmed"}})
    end
  end
end
