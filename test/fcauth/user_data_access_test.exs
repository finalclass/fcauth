defmodule FCAuth.UserDataAccessTest do
  use FCAuth.DataCase

  alias FCAuth.UserDataAccess
  
  test "inserts and then can retrieve the data" do
    data = %{email: "test@example.com", password_hash: "abc123"}
    UserDataAccess.start_link([])
    UserDataAccess.save(data)
    out = UserDataAccess.get("test@example.com")

    assert out == data
  end
  
end
