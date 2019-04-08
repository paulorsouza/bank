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

  describe "list_operations/1" do
    test "return all operations" do
      wallet = insert(:wallet_projection)

      1..5
      |> Enum.each(fn _ ->
        insert(:operation_projection, wallet_uuid: wallet.uuid)
      end)

      operations = Accounts.list_operations(wallet.uuid)

      assert Enum.count(operations) == 5
    end
  end

  describe "balance" do
    setup do
      wallet = insert(:wallet_projection)

      1..3
      |> Enum.each(fn x ->
        date_time = Timex.to_datetime({{2018, 1, x}, {0, 0, 0}}, "Etc/UTC")

        insert(:operation_projection,
          wallet_uuid: wallet.uuid,
          operation_date: date_time,
          amount: 200.00 * x
        )
      end)

      1..3
      |> Enum.each(fn x ->
        date_time = Timex.to_datetime({{2018, 1, x}, {0, 0, 0}}, "Etc/UTC")

        insert(:operation_projection,
          wallet_uuid: wallet.uuid,
          operation_date: date_time,
          amount: 100.00 * x,
          type: :withdraw
        )
      end)

      %{wallet_uuid: wallet.uuid}
    end

    test "return total balance", %{wallet_uuid: wallet_uuid} do
      assert [%{credit: 1200.0, debit: 600.0, total: 600.0}] == Accounts.get_balance(wallet_uuid)
    end

    test "return balance per day", %{wallet_uuid: wallet_uuid} do
      expected = [
        %{
          credit: 200.0,
          day: " 01",
          debit: 100.0,
          month: " 01",
          total: 100.0,
          year: " 2018"
        },
        %{
          credit: 400.0,
          day: " 02",
          debit: 200.0,
          month: " 01",
          total: 200.0,
          year: " 2018"
        },
        %{
          credit: 600.0,
          day: " 03",
          debit: 300.0,
          month: " 01",
          total: 300.0,
          year: " 2018"
        }
      ]

      assert expected == Accounts.get_balance_per_period(wallet_uuid, "day")
    end

    test "return balance per month", %{wallet_uuid: wallet_uuid} do
      expected = [%{credit: 1200.0, debit: 600.0, month: " 01", total: 600.0, year: " 2018"}]

      assert expected == Accounts.get_balance_per_period(wallet_uuid, "month")
    end

    test "return balance per year", %{wallet_uuid: wallet_uuid} do
      expected = [%{credit: 1200.0, debit: 600.0, total: 600.0, year: " 2018"}]

      assert expected == Accounts.get_balance_per_period(wallet_uuid, "year")
    end

    test "can not break when you have only one operation" do
      wallet = insert(:wallet_projection)
      insert(:operation_projection)

      assert is_list(Accounts.get_balance(wallet.uuid))
      assert is_list(Accounts.get_balance_per_period(wallet.uuid, "day"))
      assert is_list(Accounts.get_balance_per_period(wallet.uuid, "month"))
      assert is_list(Accounts.get_balance_per_period(wallet.uuid, "year"))
    end
  end
end
