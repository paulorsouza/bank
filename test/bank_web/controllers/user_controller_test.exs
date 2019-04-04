defmodule BankWeb.UserControllerTest do
  use BankWeb.ConnCase
  @moduletag :web

  import Bank.Factory

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))

      assert html_response(conn, 200) =~ "Registration"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      user_attrs = build(:user)

      conn = post(conn, Routes.user_path(conn, :create), user_attrs)

      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :info) == "User created successfully."
    end
  end
end
