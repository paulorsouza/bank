defmodule Bank.Accounts.Aggregates.WalletTest do
  use Bank.AggregateCase, aggregate: Bank.Accounts.Aggregates.Wallet

  alias Bank.Accounts.Events.WalletOpened

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
end
