defmodule Bank.Credentials.Aggregates.User do
  @moduledoc false

  defstruct [
    :uuid,
    :username,
    :email,
    :encrypted_password
  ]

  alias __MODULE__
  alias Bank.Credentials.Events.UserCreated
  alias Bank.Credentials.Commands.CreateUser

  @doc """
  Create a new user
  """
  def execute(%User{uuid: nil}, %CreateUser{} = create) do
    %UserCreated{
      user_uuid: create.user_uuid,
      username: create.username,
      email: create.email,
      encrypted_password: create.encrypted_password
    }
  end

  def apply(%User{} = user, %UserCreated{} = created) do
    %User{
      user
      | uuid: created.user_uuid,
        username: created.username,
        email: created.email,
        encrypted_password: created.encrypted_password
    }
  end
end
