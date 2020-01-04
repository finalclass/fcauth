defmodule FCAuth.Mailer do
  def deliver(mail_params) do
    Mailman.deliver(
      %Mailman.Email{
        subject: mail_params.subject,
        from: mail_params.from || "pocztmistrz@finalclass.net",
        to: mail_params.to,
        text: mail_params.text,
        html: mail_params.html
      },
      config()
    )
  end

  defp config do
    %Mailman.Context{
      config: %Mailman.SmtpConfig{
        relay: "smtp.gmail.com",
        username: "pocztmistrz@finalclass.net",
        password: Application.get_env(:fcauth, :mailer_password),
        port: 587,
        tls: :always
      },
      composer: %Mailman.EexComposeConfig{}
    }
  end
end
