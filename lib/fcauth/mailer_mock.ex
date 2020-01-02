defmodule FCAuth.MailerMock do
  def deliver(email) do
    {:ok, "okok"}
  end
end
