defmodule FCAuth.User do
  alias FCAuth.User

  defstruct email: "", password_hash: "", status: ""
  @type t :: %User{email: String.t(), password_hash: String.t(), status: String.t()}

  @spec to_tuple(t()) :: {String.t(), String.t(), String.t()}
  def to_tuple(%User{email: email, password_hash: password_hash, status: status}) do
    {email, password_hash, status}
  end

  @spec to_struct({String.t(), String.t(), String.t()}) :: t()
  def to_struct({email, password_hash, status}) do
    %User{email: email, password_hash: password_hash, status: status}
  end
end
