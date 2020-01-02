use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fcauth, FCAuthWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :bcrypt_elixir, log_rounds: 4

config :fcauth, :password_salt, "$2b$12$P5kPo9e7AVaVnToHx9jwLu"

config :fcauth, :users_data_file, "users-test-db.dets"
