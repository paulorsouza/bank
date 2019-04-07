defmodule Bank.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Bank.Repo

  alias Bank.Credentials.Projections.User
  alias Bank.Credentials.Commands.CreateUser
  alias Bank.Accounts.Projections.{Wallet, Operation}
  alias Bank.Accounts.Commands.OpenWallet
  alias Bank.Accounts.Events.WalletOpened

  def user_factory do
    %{
      username: sequence(:user, &"user#{&1}"),
      email: sequence(:email, &"email#{&1}@example.com"),
      password: "12345678",
      password_confirmation: "12345678"
    }
  end

  def user_projection_factory do
    %User{
      uuid: UUID.uuid4(),
      username: sequence(:user, &"user#{&1}"),
      email: sequence(:email, &"email#{&1}@example.com"),
      encrypted_password: "12345678"
    }
  end

  def create_user_factory do
    struct(CreateUser, build(:user))
  end

  def wallet_factory do
    %{
      user_uuid: UUID.uuid4(),
      username: sequence(:user, &"user#{&1}"),
      balance: 1000.00
    }
  end

  def wallet_projection_factory do
    %Wallet{
      uuid: UUID.uuid4(),
      user_uuid: UUID.uuid4(),
      username: sequence(:user, &"user#{&1}"),
      balance: 1000.00
    }
  end

  def operation_projection_factory do
    %Operation{
      wallet_uuid: UUID.uuid4(),
      type: :deposit,
      amount: 1000.00,
      from_user: "",
      to_user: "",
      operation_date: Timex.now()
    }
  end

  def open_wallet_factory do
    struct(OpenWallet, build(:wallet))
  end

  def wallet_opened_factory do
    struct(WalletOpened, build(:wallet))
  end
end
