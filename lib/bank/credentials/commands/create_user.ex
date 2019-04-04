defmodule Bank.Credentials.Commands.CreateUser do
  @moduledoc false

  defstruct [
    :user_uuid,
    :username,
    :email,
    :password,
    :password_confirmation,
    :encrypted_password
  ]

  use ExConstructor
  alias __MODULE__
  alias Bank.Credentials.Auth

  def assign_uuid(%CreateUser{} = create_user, uuid) do
    %CreateUser{create_user | user_uuid: uuid}
  end

  def encrypt_password(%CreateUser{password: password} = create_user) do
    %CreateUser{
      create_user
      | password: nil,
        password_confirmation: nil,
        encrypted_password: Auth.encrypt_password(password)
    }
  end
end
