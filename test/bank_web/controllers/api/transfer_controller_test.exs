defmodule BankWeb.Api.TransferControllerTest do
  use BankWeb.ConnCase

  import Bank.Factory
  alias Bank.Credentials
  alias Bank.Credentials.Projections.User

  @moduletag :api

  describe "transfer" do
    test "should return wallet with balance", %{conn: conn} do
      create_user = build(:user)
      another_user = build(:user)
      {:ok, %User{} = _user} = Credentials.create_user(create_user)
      {:ok, %User{} = another_user} = Credentials.create_user(another_user)

      transfer = %{
        "credential" => create_user.username,
        "password" => create_user.password,
        "value" => "400,00",
        "to_user" => another_user.username
      }

      conn = post conn, Routes.transfer_api_path(conn, :create), transfer
      json = json_response(conn, 200)["data"]

      assert json == %{"balance" => "R$ 600,00"}
    end

    test "should fail when to_user is a invalid user", %{conn: conn} do
      create_user = build(:user)
      {:ok, %User{} = _user} = Credentials.create_user(create_user)

      transfer = %{
        "credential" => create_user.username,
        "password" => create_user.password,
        "value" => "200,00",
        "to_user" => "invalid_user"
      }

      conn = post conn, Routes.transfer_api_path(conn, :create), transfer

      assert json_response(conn, 422)["errors"] == %{
               "detail" => "Wallet not found"
             }
    end
  end
end
