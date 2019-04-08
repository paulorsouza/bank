defmodule BankWeb.Api.BalanceControllerTest do
  use BankWeb.ConnCase

  import Bank.Factory
  alias Bank.Credentials
  alias Bank.Accounts
  alias Bank.Credentials.Projections.User
  alias Bank.Accounts.Projections.Wallet

  @moduletag :api

  describe "balance" do
    test "should return all balance by periods", %{conn: conn} do
      create_user = build(:user)
      {:ok, %User{} = user} = Credentials.create_user(create_user)

      # wait(fn ->
      #   assert %Wallet{} = Accounts.get_wallet_by_user_uuid(user.uuid)
      # end)

      wallet = Accounts.get_wallet_by_user_uuid(user.uuid)

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

      credential = %{
        "credential" => create_user.username,
        "password" => create_user.password
      }

      conn = get conn, Routes.balance_api_path(conn, :index), credential
      json = json_response(conn, 200)["data"]

      assert Enum.count(json["annual"]) == 1
      assert Enum.count(json["monthly"]) == 1
      assert Enum.count(json["daily"]) == 3
      assert Enum.count(json["total"]) == 1
    end
  end
end
