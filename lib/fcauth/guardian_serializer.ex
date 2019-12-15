defmodule FCAuth.GuardianSerializer do
  @behaviour Guardian.Serializer

  def for_token(user = %{}) do
    {:ok, "User:#{user.id}"}
  end

  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id) do
    {:ok, %{id: id, name: "test"}}
  end

  def from_token(_), do: {:error, "Unknown resource type"}
end
