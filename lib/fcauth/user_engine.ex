defmodule FCAuth.UserEngine do

  alias FCAuth.User
  alias FCAuth.UserDataAccess

  @doc ~S"""
  Create a new user

  ## Examples

    ### Creates a user
  
    iex> {:ok, user} = UserEngine.create("test100@example.com", "12345678")
    iex> user.email
    "test100@example.com"
    iex> user.password_hash
    "$2b$12$P5kPo9e7AVaVnToHx9jwLu2UuDdxxM0hOR9G2C67tmTCFsF/2BTui"
    iex> user.status
    "created"
  
    ### Can't create a user with the same email

    iex> UserDataAccess.save(%User{email: "test101@example.com", password_hash: "test", status: "created"})
    iex> UserEngine.create("test101@example.com", "12345678")
    {:error, ["user already exists"]}

    ### Requires passwords with a minimum length of 8

    iex> UserEngine.create("test101@example.com", "123")
    {:error, ["password too short (minimum 8 chars)"]}
    
  """
  @spec create(String.t(), String.t()) :: {:ok, User.t()} | {:error, list(String.t())}
  def create(email, password) do
    validation_errors = create_validation_errors()
    |> validate_user_not_exist(email)
    |> validate_password_length(password)

    if has_errors(validation_errors) do
      {:error, validation_errors}
    else
      salt = Application.get_env(:fcauth, :password_salt) || Bcrypt.gen_salt()
      user = %User{
        email: email,
        password_hash: Bcrypt.Base.hash_password(password, salt),
        status: "created",
        signup_token: Bcrypt.gen_salt() <> Bcrypt.gen_salt(),
        signup_token_generated_at: DateTime.utc_now() |> DateTime.to_unix()
      }
      UserDataAccess.save(user)
      {:ok, user}
    end
  end

  @doc ~S"""
  Confirms user by his signup token

  ## Examples
  
    iex> {:ok, user} = UserEngine.create("test200@example.com", "12345678")
    iex> UserEngine.confirm(user.signup_token)
    :ok
    iex> user = UserDataAccess.get(user.email)
    iex> user.status
    "confirmed"
    iex> user.signup_token
    ""
    iex> user.signup_token_generated_at
    0
  """
  @spec confirm(Stirng.t()) :: :ok | {:error, term()}
  def confirm(token) do
    case UserDataAccess.find_by_signup_token(token) do
      %User{} = user ->
        now = DateTime.utc_now() |> DateTime.to_unix()
        token_validity = 24 * 60 * 60 # tokens are valid 1 day
        if (now - user.signup_token_generated_at > token_validity) do
          {:error, :token_expired}
        else
          if (user.status != "created") do
	    {:error, :user_already_active}
          else
            user = %{user | signup_token: "", signup_token_generated_at: 0, status: "confirmed"}
            UserDataAccess.save(user)
            :ok
          end
        end
      _ -> :error
    end
  end

  @spec validate_password_length(list(String.t()), String.t()) :: list(String.t())
  defp validate_password_length(errors, password) do
    if (String.length(password) < 8) do
      ["password too short (minimum 8 chars)" | errors]
    else
      errors
    end
  end
  
  @spec validate_user_not_exist(list(String.t()), String.t()) :: list(String.t())
  defp validate_user_not_exist(errors, email) do
    case UserDataAccess.get(email) do
      nil -> errors
      _ -> ["user already exists" | errors]
    end
  end

  @spec has_errors(list(String.t())) :: boolean()
  defp has_errors([]), do: false
  defp has_errors(_), do: true

  @spec create_validation_errors() :: list(String.t())
  defp create_validation_errors(), do: []
  
end
