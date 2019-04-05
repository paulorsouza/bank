defmodule Bank.AccountsTest do
  use Bank.DataCase
  import Bank.Factory
  import Commanded.Assertions.EventAssertions

  alias Bank.Accounts
  alias Bank.Accounts.Events.WalletOpened
  alias Bank.Credentials
  alias Bank.Credentials.Projections.User

  describe "an wallet" do
    @describetag :eventstore

    test "should be opened when a new user was created" do
      create_user = build(:user)
      assert {:ok, %User{} = user} = Credentials.create_user(create_user)

      assert_receive_event(WalletOpened, fn event ->
        assert event.user_uuid == user.uuid
        assert event.username == user.username
        assert event.balance == 1000.00
      end)

      wallet = Accounts.get_wallet_by_user_uuid(user.uuid)
      assert wallet.balance == Decimal.new(1000)
    end
  end
end
