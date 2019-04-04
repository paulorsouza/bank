defmodule Bank.Credentials.Events.UserCreated do
  @moduledoc false

  @derive [Jason.Encoder]
  defstruct [
    :user_uuid,
    :username,
    :email,
    :encrypted_password
  ]
end
