defmodule Bank.Router do
  use Commanded.Commands.Router

  alias Bank.Credentials.Aggregates.User
  alias Bank.Credentials.Commands.CreateUser
  alias Bank.Support.Middleware.{Validate, Uniqueness}

  middleware(Validate)
  middleware(Uniqueness)

  dispatch([CreateUser], to: User, identity: :user_uuid)
end
