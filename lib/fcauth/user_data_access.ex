defmodule FCAuth.UserDataAccess do
  use GenServer
  alias FCAuth.User

  #######
  # API
  #######
  @doc "Start the process"
  @spec start_link([file_path: String.t()]) :: :ignore | {:error, {:already_started, pid()} | any()} | {:ok, pid()}
  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)

  @doc ~S"""
  Get user by email (id)

  ## Examples

  iex> UserDataAccess.save(%User{email: "test@example.com", password_hash: "abc123", status: "created"})
  iex> UserDataAccess.get("test@example.com")
  %User{email: "test@example.com", password_hash: "abc123", status: "created"}

  """
  @spec get(String.t) :: User.t() | nil
  def get(id), do: GenServer.call(__MODULE__, {:get, id})

  @doc ~S"""
  Get all users from the database


  ## Examples

      iex> UserDataAccess.save(%User{email: "test1@example.com", password_hash: "abc123", status: "created"})
      iex> UserDataAccess.save(%User{email: "test2@example.com", password_hash: "abc123", status: "created"})
      iex> UserDataAccess.all()
      [
        %User{email: "test2@example.com", password_hash: "abc123", status: "created"},
        %User{email: "test1@example.com", password_hash: "abc123", status: "created"}
      ]

  """
  @spec all() :: list(User.t())
  def all(), do: GenServer.call(__MODULE__, {:all})

  @doc ~S"""
  Searches for a user by token

  ## Examples
  
    iex> UserDataAccess.save(%User{email: "test5@example.com", signup_token: "my-token"})
    iex> UserDataAccess.find_by_signup_token("my-token")
    %User{email: "test5@example.com", signup_token: "my-token"}
  """
  @spec find_by_signup_token(String.t()) :: User.t() | nil
  def find_by_signup_token(token), do: GenServer.call(__MODULE__, {:find_by_signup_token, token})
  
  @doc ~S"""
  Save (insert of update) the user

  ## Examples

    ### Save a new document

    iex> UserDataAccess.save(%User{email: "test@example.com", password_hash: "abc123", status: "created"})
    :ok
    iex> UserDataAccess.get("test@example.com")
    %User{email: "test@example.com", password_hash: "abc123", status: "created"}

    ### Updates existing

    iex> UserDataAccess.save(%User{email: "test@example.com", password_hash: "changed", status: "created"})
    :ok
    iex> UserDataAccess.all()
    [%User{email: "test@example.com", password_hash: "changed", status: "created"}]

  """
  @spec save(User.t()) :: :ok | {:error, any()}
  def save(user), do: GenServer.call(__MODULE__, {:save, user})

  @doc ~S"""
  Delete a user by email (id)

  ## Examples

    iex> UserDataAccess.save(%User{email: "test1@example.com", password_hash: "abc123", status: "created"})
    iex> UserDataAccess.delete("test1@example.com")
    iex> UserDataAccess.get("test1@example.com")
    nil

"""
  @spec delete(String.t()) :: :ok | {:error, any()}
  def delete(user_id), do: GenServer.call(__MODULE__, {:delete, user_id})

  #######
  # impl
  #######

  @type user_da_state :: %{table: reference()}

  @impl true
  @spec init([file_path: String.t()]) :: {:ok, user_da_state()}
  def init(file_path: file_path) do
    {:ok, table} = :dets.open_file(String.to_atom(file_path), [type: :set])
    {:ok, %{table: table}}
  end

  @impl true
  def handle_call({:get, id}, _from, %{table: table} = state) do
    user = case :dets.lookup(table, id) |> List.first() do
             nil -> nil
             data -> User.to_struct(data)
           end
    {:reply, user, state}
  end

  @impl true
  def handle_call({:all}, _from, %{table: table} = state) do
    users = :dets.match(table, :"$1")
    |> Enum.map(fn [tuple|_] -> User.to_struct(tuple) end)

    {:reply, users, state}
  end

  @impl true
  def handle_call({:save, user}, _from, %{table: table} = state) do
    result = :dets.insert(table, user |> User.to_tuple())
    {:reply, result, state}
  end

  @impl true
  def handle_call({:delete, user_id}, _from, %{table: table} = state) do
    result = :dets.delete(table, user_id)
    {:reply, result, state}
  end

  @impl true
  def handle_call({:find_by_signup_token, token}, _from, %{table: table} = state) do
    user = case :dets.match_object(table, User.signup_token_matcher(token)) do
             [u|_] -> User.to_struct(u)
             _ -> nil
           end
    {:reply, user, state}
  end
  
end
