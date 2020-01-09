defmodule FCAuth.User do
  alias FCAuth.User

  defstruct email: "", password_hash: "", status: :created, signup_token: "", signup_token_generated_at: 0, roles: []
  @type t :: %User{
    email: String.t(),
    password_hash: String.t(),
    status: atom(),
    signup_token: String.t(),
    signup_token_generated_at: integer(),
    roles: list(String.t())
  }

  @spec to_tuple(t()) :: {String.t(), String.t(), atom(), String.t(), integer(), list(String.t())}
  def to_tuple(%User{} = user) do
    {user.email, user.password_hash, user.status, user.signup_token, user.signup_token_generated_at, user.roles}
  end

  @spec to_struct({String.t(), String.t(), atom(), String.t(), integer(), list(String.t())}) :: t()
  def to_struct({email, password_hash, status, signup_token, signup_token_generated_at, roles}) do
    %User{
      email: email,
      password_hash: password_hash,
      status: status,
      signup_token: signup_token,
      signup_token_generated_at: signup_token_generated_at,
      roles: roles
    }
  end

  @spec signup_token_matcher(String.t()) :: tuple()
  def signup_token_matcher(token) do
    {:_, :_, :_, token, :_, :_}
  end

  @spec status_matcher(atom()) :: tuple()
  def status_matcher(status) do
    {:_, :_, status, :_, :_, :_}
  end
end
