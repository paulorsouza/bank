defmodule BankWeb.Api.WithdrawControllerTest do
  use BankWeb.ConnCase

  import Bank.Factory
  alias Bank.Credentials
  alias Bank.Credentials.Projections.User

  @moduletag :api

  describe "withdraw" do
    test "should return wallet with new balance", %{conn: conn} do
      create_user = build(:user)
      {:ok, %User{} = _user} = Credentials.create_user(create_user)

      withdraw = %{
        "credential" => create_user.username,
        "password" => create_user.password,
        "value" => "200,00"
      }

      conn = post conn, Routes.withdraw_api_path(conn, :create), withdraw
      json = json_response(conn, 200)["data"]

      assert json == %{
               "balance" => "R$ 800,00"
             }
    end

    test "should fail with invalid value", %{conn: conn} do
      create_user = build(:user)
      {:ok, %User{} = _user} = Credentials.create_user(create_user)

      withdraw = %{
        "credential" => create_user.username,
        "password" => create_user.password,
        "value" => "invalid value"
      }

      conn = post conn, Routes.withdraw_api_path(conn, :create), withdraw

      assert json_response(conn, 400)["errors"] == %{
               "detail" => "Bad Request"
             }
    end
  end
end
