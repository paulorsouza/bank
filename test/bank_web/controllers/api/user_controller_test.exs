defmodule BankWeb.Api.UserControllerTest do
  use BankWeb.ConnCase

  import Bank.Factory

  @moduletag :api

  describe "create user" do
    test "should create and return user when data is valid", %{conn: conn} do
      user = %{
        "username" => "teste",
        "email" => "email@email.com",
        "password" => "12345678"
      }

      conn = post conn, Routes.user_api_path(conn, :create), user
      json = json_response(conn, 201)["data"]

      assert json == %{
               "email" => "email@email.com",
               "username" => "teste"
             }
    end

    test "should not create user and render errors when data is invalid", %{conn: conn} do
      user = %{
        "username" => "teste",
        "email" => "invalid_email",
        "password" => "12345678"
      }

      conn = post conn, Routes.user_api_path(conn, :create), user

      assert json_response(conn, 422)["errors"] == %{
               "email" => [
                 "is invalid"
               ]
             }
    end

    test "should not create user and render errors when username has been taken", %{conn: conn} do
      insert(:user_projection, username: "sameuser")

      user = %{
        "username" => "sameuser",
        "email" => "email@email.com",
        "password" => "12345678"
      }

      conn = post conn, Routes.user_api_path(conn, :create), user

      assert json_response(conn, 422)["errors"] == %{
               "username" => [
                 "has already been taken"
               ]
             }
    end
  end
end
