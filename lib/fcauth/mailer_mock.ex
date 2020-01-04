defmodule FCAuth.MailerMock do
  use Agent

  def start_link(initial_value \\ []) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def clear_invocations() do
    Agent.update(__MODULE__, fn _ -> [] end)
  end
  
  def push_invocation(email) do
    Agent.update(__MODULE__, fn state -> [email | state] end)
  end

  def pop_invocation() do
    Agent.get_and_update(__MODULE__, fn
      [invocation | state] -> {invocation, state}
      _ -> {nil, []}
    end)
  end

  def deliver(mail_params) do
    push_invocation(mail_params)
    {:ok, "ok"}
  end
end
