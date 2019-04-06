defmodule Bank.Accounts.Aggregates.WalletTest do
  use Bank.AggregateCase, aggregate: Bank.Accounts.Aggregates.Wallet

  alias Bank.Accounts.Events.{WalletOpened, Withdrawn, Deposited}
  alias Bank.Accounts.Commands.{Withdraw, Deposit}

  describe "open wallet" do
    @tag :aggregates
    test "should succeed when valid" do
      wallet_uuid = UUID.uuid4()
      open_wallet = build(:open_wallet, wallet_uuid: wallet_uuid)

      assert_events(open_wallet, [
        %WalletOpened{
          wallet_uuid: open_wallet.wallet_uuid,
          user_uuid: open_wallet.user_uuid,
          username: open_wallet.username,
          balance: open_wallet.balance
        }
      ])
    end
  end

  describe "withdraw" do
    @describetag :aggregates
    test "should succeed when valid" do
      wallet_uuid = UUID.uuid4()
      wallet_opened = build(:wallet_opened, wallet_uuid: wallet_uuid)

      assert_events(wallet_opened, %Withdraw{wallet_uuid: wallet_uuid, amount: 300.00}, [
        %Withdrawn{
          wallet_uuid: wallet_uuid,
          amount: 300.00,
          new_balance: 700.00
        }
      ])
    end

    test "should fail when withdraw amount is great than balance" do
      wallet_uuid = UUID.uuid4()
      wallet_opened = build(:wallet_opened, wallet_uuid: wallet_uuid)

      assert_error(
        wallet_opened,
        %Withdraw{wallet_uuid: wallet_uuid, amount: 1300.00},
        {:error, :insufficient_funds}
      )
    end

    test "should fail when wallet is not found" do
      wallet_opened = build(:wallet_opened, wallet_uuid: nil)

      assert_error(
        wallet_opened,
        %Withdraw{wallet_uuid: nil, amount: 1300.00},
        {:error, :wallet_not_found}
      )
    end
  end

  describe "deposit" do
    @describetag :aggregates
    test "should succeed when valid" do
      wallet_uuid = UUID.uuid4()
      wallet_opened = build(:wallet_opened, wallet_uuid: wallet_uuid)

      assert_events(wallet_opened, %Deposit{wallet_uuid: wallet_uuid, amount: 300.00}, [
        %Deposited{
          wallet_uuid: wallet_uuid,
          amount: 300.00,
          new_balance: 1300.00
        }
      ])
    end

    test "should fail when wallet is not found" do
      wallet_opened = build(:wallet_opened, wallet_uuid: nil)

      assert_error(
        wallet_opened,
        %Deposit{wallet_uuid: nil, amount: 1300.00},
        {:error, :wallet_not_found}
      )
    end
  end
end
