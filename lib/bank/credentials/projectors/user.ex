defmodule Bank.Credentials.Projectors.User do
  @moduledoc false

  use Commanded.Projections.Ecto,
    name: "Credentials.Projectors.User",
    consistency: :strong

  alias Bank.Credentials.Events.UserCreated
  alias Bank.Credentials.Projections.User

  project(%UserCreated{} = created, fn multi ->
    Ecto.Multi.insert(multi, :user, %User{
      uuid: created.user_uuid,
      username: created.username,
      email: created.email,
      encrypted_password: created.encrypted_password
    })
  end)
end
