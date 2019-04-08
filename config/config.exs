# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bank,
  ecto_repos: [Bank.Repo]

# Configures the endpoint
config :bank, BankWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KmJW1wEhsYI3e6RP5HGscIrc4QEwMFAoLTTpCPBzT5A5aaY3ETQZTsDcR2sea5pR",
  render_errors: [view: BankWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bank.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :commanded_ecto_projections,
  repo: Bank.Repo

config :vex,
  sources: [
    Bank.Credentials.Validators,
    Bank.Support.Validators,
    Vex.Validators
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Bamboo
config :bank, Bank.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.gmail.com",
  port: 587,
  username: "mailertabajara@gmail.com",
  password: "23tNGp8uNEYWxYh",
  tls: :if_available,
  ssl: false,
  retries: 1
