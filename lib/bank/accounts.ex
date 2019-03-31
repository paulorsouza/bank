defmodule Bank.Accounts do
  @moduledoc false

  import Ecto.Query, warn: false

  alias Bank.Repo
  alias Bank.Accounts.User

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_admin(attrs \\ %{}) do
    %User{}
    |> User.create_admin_changeset(attrs)
    |> Repo.insert()
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  # runs the hash function, but always returns false
  def valid_password?(nil, _given_password) do
    Pbkdf2.no_user_verify()
  end

  def valid_password?(user, given_password) do
    Pbkdf2.verify_pass(given_password, user.encrypted_password)
  end
end
