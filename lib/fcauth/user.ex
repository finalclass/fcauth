defmodule FCAuth.User do
  alias FCAuth.User
  
  defstruct email: "", password_hash: ""
  @type t :: %User{email: String.t, password_hash: String.t}

  @spec to_tuple(t()) :: {String.t, String.t}
  def to_tuple(%User{email: email, password_hash: password_hash}) do
    {email, password_hash}
  end

  @spec to_struct(tuple()) :: t()
  def to_struct({email, password_hash}) do
    %User{email: email, password_hash: password_hash}
  end

end
