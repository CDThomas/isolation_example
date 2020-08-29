# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :isolation_example,
  ecto_repos: [IsolationExample.Repo, IsolationExample.RepoTwo]

# Configures the endpoint
config :isolation_example, IsolationExampleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mznUnVdrSJ8bRkyejml06iHoSPAgiKRr+4to0elTrT1qkCJt9EhxrKpHrZZoeIad",
  render_errors: [view: IsolationExampleWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: IsolationExample.PubSub,
  live_view: [signing_salt: "pnqnAqE8"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
