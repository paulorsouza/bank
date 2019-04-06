defmodule Bank.Router do
  use Commanded.Commands.Router

  alias Bank.Credentials.Aggregates.User
  alias Bank.Credentials.Commands.CreateUser
  alias Bank.Accounts.Aggregates.Wallet
  alias Bank.Accounts.Commands.{OpenWallet, Withdraw, Deposit}
  alias Bank.Support.Middleware.{Validate, Uniqueness}

  middleware(Validate)
  middleware(Uniqueness)

  identify(User, by: :user_uuid, prefix: "user-")
  identify(Wallet, by: :wallet_uuid, prefix: "wallet-")

  dispatch([CreateUser], to: User)
  dispatch([OpenWallet, Withdraw, Deposit], to: Wallet)
end
