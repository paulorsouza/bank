defmodule Bank.Router do
  use Commanded.Commands.Router

  alias Bank.Credentials.Aggregates.User
  alias Bank.Credentials.Commands.CreateUser
  alias Bank.Accounts.Aggregates.Wallet
  alias Bank.Accounts.Commands.OpenWallet
  alias Bank.Support.Middleware.{Validate, Uniqueness}

  middleware(Validate)
  middleware(Uniqueness)

  dispatch([CreateUser], to: User, identity: :user_uuid)
  dispatch([OpenWallet], to: Wallet, identity: :wallet_uuid)
end
