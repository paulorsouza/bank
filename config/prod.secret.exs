use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :playfair, BankWeb.Endpoint,
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

# Configure your database
config :playfair, BankWeb.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true
