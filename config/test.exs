use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bank, BankWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :rollbax, enabled: :log

# Configure your database
config :bank, Bank.Repo,
  username: "postgres",
  password: "postgres",
  database: "bank_readstore_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :commanded,
  event_store_adapter: Commanded.EventStore.Adapters.InMemory

config :commanded, Commanded.EventStore.Adapters.InMemory,
  serializer: Commanded.Serialization.JsonSerializer

# Bamboo
config :bank, Bank.Mailer, adapter: Bamboo.TestAdapter
