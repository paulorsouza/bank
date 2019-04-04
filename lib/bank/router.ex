defmodule Bank.Router do
  use Commanded.Commands.Router

  alias Bank.Credentials.Aggregates.User
  alias Bank.Credentials.Commands.CreateUser

  dispatch([CreateUser], to: User, identity: :user_uuid)
end
