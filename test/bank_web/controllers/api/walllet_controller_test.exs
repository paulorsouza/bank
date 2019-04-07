defmodule BankWeb.Api.WalletControllerTest do
  use BankWeb.ConnCase

  import Bank.Factory
  alias Bank.Credentials
  alias Bank.Credentials.Projections.User

  @moduletag :api

  describe "wallet" do
    test "should return wallet with balance", %{conn: conn} do
      create_user = build(:user)
      {:ok, %User{} = _user} = Credentials.create_user(create_user)

      credential = %{
        "credential" => create_user.username,
        "password" => create_user.password
      }

      conn = get conn, Routes.wallet_api_path(conn, :show), credential
      json = json_response(conn, 200)["data"]

      assert json == %{"balance" => "R$ 1000,00"}
    end
  end
end
