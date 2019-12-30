defmodule FCAuth.GuardianSerializer do
  @behaviour Guardian.Serializer

  def for_token(user = %{}) do
    {:ok, "{\"sub\":\"#{user.id}\"}"}
  end

  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token(json) do

    token = Jason.decode!(json)
    IO.inspect({"from_token", token})
    {:ok, %{id: "testId", name: "testName"}}
  end

end
