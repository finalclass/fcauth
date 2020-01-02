defmodule FCAuth.Mailer do
  def deliver(email) do
    Mailman.deliver(
      %Mailman.Email{
        subject: email.subject,
        from: email.from || "fcauth@finalclass.net",
        to: email.to,
        text: email.text,
        html: email.html
      },
      config()
    )
  end

  def config do
    %Mailman.Context{
      config: %Mailman.SmtpConfig{
        relay: "smtp.gmail.com",
        username: "s@finalclass.net",
        password: Application.get_env(:fcauth, :mailer_password),
        port: 587,
        tls: :always
      },
      composer: %Mailman.EexComposeConfig{}
    }
  end
end
