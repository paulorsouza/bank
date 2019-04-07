defmodule Bank.ReadStore.AccountsTest do
  use Bank.DataCase
  import Bank.Factory

  alias Bank.Accounts

  @moduletag :readstore

  describe "get_wallet/1" do
    test "returns the wallet with given uuid" do
      wallet_projection = insert(:wallet_projection)

      wallet = Accounts.get_wallet(wallet_projection.uuid)

      assert wallet_projection.username == wallet.username
    end
  end

  describe "get_wallet_by_user_uuid/1" do
    test "returns the wallet with given user uuid" do
      wallet_projection = insert(:wallet_projection)

      wallet = Accounts.get_wallet_by_user_uuid(wallet_projection.user_uuid)

      assert wallet_projection.username == wallet.username
    end
  end

  describe "get_wallet_by_user_name/1" do
    test "returns the wallet with given user name" do
      wallet_projection = insert(:wallet_projection)

      {:ok, wallet} = Accounts.get_wallet_by_user_name(wallet_projection.username)

      assert wallet_projection.username == wallet.username
    end

    test "returns :error with invalid username" do
      assert {:error, :wallet_not_found} == Accounts.get_wallet_by_user_name("")
    end
  end
end
