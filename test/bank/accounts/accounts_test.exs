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

  describe "chaotic operations" do
    @describetag :fragile
    test "should project correct operations", %{wallet: wallet, user: user} do
      [
        Task.async(fn -> Accounts.withdraw(wallet, 300.00) end),
        Task.async(fn -> Accounts.withdraw(wallet, 2000.00) end),
        Task.async(fn -> Accounts.withdraw(wallet, 300.00) end),
        Task.async(fn -> Accounts.withdraw(wallet, 300.00) end),
        Task.async(fn -> Accounts.withdraw(wallet, 300.00) end)
      ]
      # balance 100.00
      |> Enum.map(&Task.await/1)

      [
        Task.async(fn -> Accounts.deposit(wallet, 100.00) end),
        Task.async(fn -> Accounts.deposit(wallet, 250.00) end),
        Task.async(fn -> Accounts.deposit(wallet, 560.00) end)
      ]
      # balance 1100.00
      |> Enum.map(&Task.await/1)
      |> Enum.map(fn x -> IO.inspect(x) end)

      wallet_updated = Accounts.get_wallet_by_user_uuid(user.uuid)

      # This is a fragile test because operations use eventual consitency,
      # We can use strong consistency to operations, but this project is experimental :D/
      :timer.sleep(1000)
      assert wallet_updated.balance == 1010.00
    end
  end
end
