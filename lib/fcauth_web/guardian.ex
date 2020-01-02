defmodule FCAuthWeb.Guardian do
  use Guardian, otp_app: :fcauth
  alias FCAuth.UserDataAccess

  def subject_for_token(user, _claims) do
    {:ok, user.email}
  end

  def resource_from_claims(%{"sub" => email}) do
    case UserDataAccess.get(email) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end
end
