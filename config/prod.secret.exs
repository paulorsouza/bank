use Mix.Config

config :rollbax,
  enabled: true,
  environment: to_string(Mix.env()),
  access_token: System.get_env("ROLLBAR_ACCESS_TOKEN")

config :bank, BankWeb.Endpoint, secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

config :bank, Bank.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  url: System.get_env("HEROKU_POSTGRESQL_MAUVE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "15")
