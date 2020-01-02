defmodule FCAuth.UserTest do
  use FCAuth.DataCase
  alias FCAuth.UserDataAccess
  alias FCAuth.UserEngine
  alias FCAuth.User
  
  doctest UserDataAccess
  doctest UserEngine

  setup do
    UserDataAccess.all() |> Enum.each(fn user -> UserDataAccess.delete(user.email) end)
        
    on_exit(fn ->
      UserDataAccess.all() |> Enum.each(fn user -> UserDataAccess.delete(user.email) end)
    end)
  end
  
end
