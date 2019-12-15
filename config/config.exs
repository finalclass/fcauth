# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :fcauth, FcauthWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5BzdRXOQ8RGgZySooPjYM3jUd46O1sfSNjkZgdrk7p+hhzD5ndYvo4VBc4a2FmN/",
  render_errors: [view: FcauthWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Fcauth.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :guardian, Guardian,
  issuer: "FCAuth",
  secret_key: "not too secret",
  serializer: FCAuth.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
