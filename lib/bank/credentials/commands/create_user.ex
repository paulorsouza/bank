defmodule Bank.Credentials.Commands.CreateUser do
  @moduledoc false

  defstruct user_uuid: nil,
            username: "",
            email: "",
            password: "",
            password_confirmation: "",
            encrypted_password: nil

  use ExConstructor
  use Vex.Struct

  alias __MODULE__
  alias Bank.Credentials.Auth
  alias Bank.Credentials.Validators.{UniqueEmail, UniqueUsername}

  @valid_email_format ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/
  @valid_username_format ~r/^[a-z0-9]+$/

  validates(:user_uuid, uuid: true)

  validates(:password,
    presence: [message: "can't be blank"],
    length: [min: 6],
    confirmation: true
  )

  validates(:username,
    format: [
      with: @valid_username_format,
      allow_nil: true,
      allow_blank: true,
      message: "is invalid"
    ],
    length: [in: 2..20],
    by: &UniqueUsername.validate/2
  )

  validates(:email,
    presence: [message: "can't be blank"],
    format: [with: @valid_email_format, allow_nil: true, allow_blank: true, message: "is invalid"],
    by: &UniqueEmail.validate/2
  )

  def assign_uuid(%CreateUser{} = create_user, uuid) do
    %CreateUser{create_user | user_uuid: uuid}
  end

  def encrypt_password(%CreateUser{password: password} = create_user) do
    %CreateUser{
      create_user
      | encrypted_password: Auth.encrypt_password(password)
    }
  end

  defimpl Bank.Support.Middleware.Uniqueness.UniqueFields,
    for: Bank.Credentials.Commands.CreateUser do
    def unique(%Bank.Credentials.Commands.CreateUser{user_uuid: user_uuid}) do
      [
        {:email, "has already been taken", user_uuid},
        {:username, "has already been taken", user_uuid}
      ]
    end
  end
end
