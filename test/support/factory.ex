defmodule Bank.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Bank.Repo

  alias Bank.Accounts.User

  @spec user_factory() :: Bank.Accounts.User.t()
  def user_factory do
    %User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      encrypted_password: "12345678",
      role: :user
    }
  end
end
