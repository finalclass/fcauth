defmodule FCAuth.UserDataAccess do
  use GenServer

  @spec to_tuple(%{email: String.t, password_hash: String.t}) :: {String.t, String.t}
  defp to_tuple(%{email: email, password_hash: password_hash}) do
    {email, password_hash}
  end

  defp to_struct({email, password_hash}) do
    %{email: email, password_hash: password_hash}
  end

  def get(id), do: GenServer.call(__MODULE__, {:get, id})
  def all(), do: GenServer.call(__MODULE__, {:all})
  def save(user), do: GenServer.call(__MODULE__, {:save, user})
  def delete(user_id), do: GenServer.call(__MODULE__, {:delete, user_id})
  def start_link(opts), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  @impl true
  def init(_) do
    {:ok, table} = :dets.open_file(:disk_storage, [type: :set])
    {:ok, %{table: table}}
  end

  @impl true
  def handle_call({:get, id}, _from, %{table: table} = state) do
    user = :dets.lookup(table, id) |> List.first() |> to_struct()
    {:reply, user, state}
  end

  @impl true
  def handle_call({:all}, _from, %{table: table} = state) do
    users = :dets.match(table, :"$1")
    {:reply, users, state}
  end

  @impl true
  def handle_call({:save, user}, _from, %{table: table} = state) do
    result = :dets.insert_new(table, user |> to_tuple())
    {:reply, result, state}
  end

  @impl true
  def handle_call({:delete, user_id}, _from, %{table: table} = state) do
    result = :dets.delete(table, user_id)
    {:reply, result, state}
  end
  
end
