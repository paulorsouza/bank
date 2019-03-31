defmodule Bank.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @valid_email_format ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :pass, :string, virtual: true
    field :pass_confirmation, :string, virtual: true
    field :encrypted_password, :string
    field :role, UserRoles, default: :user

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :pass, :pass_confirmation])
    |> validate_required([:email, :pass, :pass_confirmation])
    |> validate_format(:email, @valid_email_format)
    |> validate_length(:pass, min: 6, max: 80)
    |> validate_confirmation(:pass)
    |> unique_constraint(:email)
    |> encrypt_password()
  end

  def create_admin_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> put_change(:role, :admin)
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{pass: pw}} ->
        put_change(changeset, :encrypted_password, Pbkdf2.hash_pwd_salt(pw))

      _ ->
        changeset
    end
  end
end
