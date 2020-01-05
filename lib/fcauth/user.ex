defmodule FCAuth.User do
  alias FCAuth.User

  defstruct email: "", password_hash: "", status: "", signup_token: "", signup_token_generated_at: 0
  @type t :: %User{
    email: String.t(),
    password_hash: String.t(),
    status: String.t(),
    signup_token: String.t(),
    signup_token_generated_at: integer()
  }

  @spec to_tuple(t()) :: {String.t(), String.t(), String.t(), String.t(), integer()}
  def to_tuple(%User{} = user) do
    {user.email, user.password_hash, user.status, user.signup_token, user.signup_token_generated_at}
  end

  @spec to_struct({String.t(), String.t(), String.t(), String.t(), integer()}) :: t()
  def to_struct({email, password_hash, status, signup_token, signup_token_generated_at}) do
    %User{
      email: email,
      password_hash: password_hash,
      status: status,
      signup_token: signup_token,
      signup_token_generated_at: signup_token_generated_at
    }
  end

  @spec signup_token_matcher(String.t()) :: tuple()
  def signup_token_matcher(token) do
    {:_, :_, :_, token, :_}
  end
end
