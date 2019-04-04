defmodule Bank.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Bank.Repo

  alias Bank.Credentials.Projections.User
  alias Bank.Credentials.Commands.CreateUser

  def user_factory do
    %{
      username: sequence(:user, &"user=#{&1}"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: "12345678",
      password_confirmation: "12345678"
    }
  end

  def user_projection_factory do
    %User{
      id: UUID.uuid4(),
      username: sequence(:user, &"user=#{&1}"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      encrypted_password: "12345678"
    }
  end

  def create_user_factory do
    struct(CreateUser, build(:user))
  end
end
