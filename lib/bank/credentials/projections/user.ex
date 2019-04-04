defmodule Bank.Credentials.Projections.User do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "users" do
    field :username, :string, unique: true
    field :email, :string, unique: true
    field :encrypted_password, :string

    timestamps()
  end
end
