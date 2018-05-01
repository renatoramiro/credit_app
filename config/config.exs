# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :credit_app,
  ecto_repos: [CreditApp.Repo]

# Configures the endpoint
config :credit_app, CreditAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "p/Y7R9ydgIJacnhsi8takx7I6Lv0G8q9fflkFcLwD/Xi1Dj/ozqwDAIwPHkeCbWN",
  render_errors: [view: CreditAppWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: CreditApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :credit_app, CreditApp.Auth.Guardian,
  issuer: "credit_app",
  secret_key: "QVJcxAQwT3QRxhuyd9UwOBjaABZS8pXIRxxXy8qIouN30cPeGUycGSg7jSGBX7QR"


config :cors_plug,
  origin: ["*"],
  max_age: 86400,
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  expose: ["authorization"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
