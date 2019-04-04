defmodule Bank.Credentials.Projections.User do
  @moduledoc false

  use Ecto.Schema

  @derive {Phoenix.Param, key: :uuid}
  @primary_key {:uuid, :binary_id, autogenerate: false}
  schema "users" do
    field :username, :string
    field :email, :string
    field :encrypted_password, :string

    timestamps()
  end
end
