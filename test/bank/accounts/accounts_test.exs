defmodule Bank.AccountsTest do
  use Bank.DataCase
  import Bank.Factory
  import Commanded.Assertions.EventAssertions

  alias Bank.Accounts
  alias Bank.Accounts.Projections.Wallet
  alias Bank.Accounts.Events.WalletOpened
  alias Bank.Credentials
  alias Bank.Credentials.Projections.User

  setup do
    create_user = build(:user)
    assert {:ok, %User{} = user} = Credentials.create_user(create_user)
    wallet = Accounts.get_wallet_by_user_uuid(user.uuid)

    %{wallet: wallet, user: user}
  end

  describe "an wallet" do
    @describetag :eventstore

    test "should be opened when a new user was created", %{user: user} do
      assert_receive_event(WalletOpened, fn event ->
        assert event.user_uuid == user.uuid
        assert event.username == user.username
        assert event.balance == 1000.00
      end)
    end
  end

  describe "withdraw" do
    @describetag :eventstore

    test "subtracts balance in wallet", %{wallet: wallet} do
      assert {:ok, %Wallet{} = wallet} = Accounts.withdraw(wallet, 300.00)
      assert {:ok, %Wallet{} = wallet} = Accounts.withdraw(wallet, 300.00)

      assert wallet.balance == 400.00
    end

    test "returns error when amount is greater than balance", %{wallet: wallet} do
      assert {:error, :insufficient_funds} = Accounts.withdraw(wallet, 1000.01)
    end

    test "should fail when asyncronous request sum of amount is greader than balance", %{
      wallet: wallet
    } do
      withdraw1 = Task.async(fn -> Accounts.withdraw(wallet, 600.00) end)
      withdraw2 = Task.async(fn -> Accounts.withdraw(wallet, 600.00) end)
      assert {:ok, %Wallet{} = wallet} = Task.await(withdraw1)
      assert {:error, :insufficient_funds} = Task.await(withdraw2)
    end
  end

  describe "deposit" do
    @describetag :eventstore

    test "adds balance in wallet", %{wallet: wallet} do
      assert {:ok, %Wallet{} = wallet} = Accounts.deposit(wallet, 300.00)
      assert {:ok, %Wallet{} = wallet} = Accounts.deposit(wallet, 300.00)

      assert wallet.balance == 1600.00
    end
  end
end
