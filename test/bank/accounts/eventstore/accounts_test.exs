defmodule Bank.EventStore.AccountsTest do
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
      wallet_uuid = wallet.uuid
      assert {:ok, %Wallet{} = wallet} = Accounts.withdraw(wallet_uuid, 300.00)
      assert {:ok, %Wallet{} = wallet} = Accounts.withdraw(wallet_uuid, 300.00)

      assert wallet.balance == 400.00
    end

    test "shoud fail when amount is greater than balance", %{wallet: wallet} do
      assert {:error, :insufficient_funds} = Accounts.withdraw(wallet.uuid, 1000.01)
    end

    test "should fail when asyncronous request sum of amount is greader than balance", %{
      wallet: wallet,
      user: user
    } do
      wallet_uuid = wallet.uuid

      Task.async(fn -> Accounts.withdraw(wallet_uuid, 600.00) end)
      Task.async(fn -> Accounts.withdraw(wallet_uuid, 600.00) end)

      wait(fn ->
        wallet_updated = Accounts.get_wallet_by_user_uuid(user.uuid)
        assert wallet_updated.balance == 400.00
      end)
    end
  end

  describe "deposit" do
    @describetag :eventstore

    test "adds balance in wallet", %{wallet: wallet} do
      wallet_uuid = wallet.uuid

      assert {:ok, %Wallet{} = wallet} = Accounts.deposit(wallet_uuid, 300.00)
      assert {:ok, %Wallet{} = wallet} = Accounts.deposit(wallet_uuid, 300.00)

      assert wallet.balance == 1600.00
    end
  end

  describe "transfer" do
    @describetag :transfer

    setup %{wallet: wallet1} do
      create_user = build(:user)
      {:ok, %User{} = user} = Credentials.create_user(create_user)
      wallet2 = Accounts.get_wallet_by_user_uuid(user.uuid)

      %{wallet1: wallet1.uuid, wallet2: wallet2.uuid}
    end

    test "should remove money from wallet 1 and add to wallet 2", %{
      wallet1: wallet1,
      wallet2: wallet2
    } do
      Accounts.send_money(wallet1, wallet2, 200.00)
      Accounts.send_money(wallet1, wallet2, 200.00)
      Accounts.send_money(wallet1, wallet2, 200.00)
      Accounts.send_money(wallet1, wallet2, 300.00)

      wallet1_updated = Accounts.get_wallet(wallet1)
      assert wallet1_updated.balance == 100.00

      wait(fn ->
        wallet2_updated = Accounts.get_wallet(wallet2)
        assert wallet2_updated.balance == 1900.00
      end)
    end

    test "shoud fail when amount sent is greater than balance", %{
      wallet1: wallet1,
      wallet2: wallet2
    } do
      assert {:error, :insufficient_funds} = Accounts.send_money(wallet1, wallet2, 2000.00)
    end

    test "should fail when asyncronous request sum of sent money is greader than balance", %{
      wallet1: wallet1,
      wallet2: wallet2,
      user: user
    } do
      Task.async(fn -> Accounts.send_money(wallet1, wallet2, 600.00) end)
      Task.async(fn -> Accounts.send_money(wallet1, wallet2, 600.00) end)

      wait(fn ->
        wallet_updated = Accounts.get_wallet_by_user_uuid(user.uuid)
        assert wallet_updated.balance == 400.00
      end)
    end
  end

  describe "chaotic operations" do
    @describetag :fragile
    test "should project correct operations", %{wallet: wallet, user: user} do
      wallet_uuid = wallet.uuid

      [
        Task.async(fn -> Accounts.withdraw(wallet_uuid, 300.00) end),
        Task.async(fn -> Accounts.withdraw(wallet_uuid, 2000.00) end),
        Task.async(fn -> Accounts.withdraw(wallet_uuid, 300.00) end),
        Task.async(fn -> Accounts.withdraw(wallet_uuid, 300.00) end),
        Task.async(fn -> Accounts.withdraw(wallet_uuid, 300.00) end)
      ]
      # balance 100.00
      |> Enum.map(&Task.await/1)

      [
        Task.async(fn -> Accounts.deposit(wallet_uuid, 100.00) end),
        Task.async(fn -> Accounts.deposit(wallet_uuid, 250.00) end),
        Task.async(fn -> Accounts.deposit(wallet_uuid, 560.00) end)
      ]
      # balance 1100.00
      |> Enum.map(&Task.await/1)

      wait(fn ->
        wallet_updated = Accounts.get_wallet_by_user_uuid(user.uuid)
        assert wallet_updated.balance == 1010.00
      end)
    end
  end
end
