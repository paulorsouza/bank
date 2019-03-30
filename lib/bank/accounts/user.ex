defmodule Bank.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :role, :integer

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :encrypted_password])
    |> validate_required([:email, :encrypted_password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def create_user_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> put_change(:role, 0)
  end

  def create_admin_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> put_change(:role, 10)
  end
end
