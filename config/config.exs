# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the namespace used by Phoenix generators
config :simply_learn,
  namespace: SL

# Configures the endpoint
config :simply_learn, SL.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "ERXZ4UMH8oCYQiX3GYTJOnWeepO2lKmtFmaWKZkhRaJPbNmgheM1FzMZeF2dZISD",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: SL.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: true

config :simply_learn,
  ecto_repos: [SL.Repo]

config :simply_learn,
  upcitemdb_endpoint: "https://api.upcitemdb.com/prod/trial/lookup"

config :simply_learn,
  amazon_search_endpoint: "https://www.amazon.co.uk/s/ref=nb_sb_noss"

config :oauth2, Google,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")
