defmodule BankWeb.UserControllerTest do
  use BankWeb.ConnCase
  import Bank.Factory

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))

      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      user_attrs = params_for(:user)

      conn = post(conn, Routes.user_path(conn, :create), user: user_attrs)

      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :info) == "User created successfully."
    end

    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = %{email: nil, encrypted_password: nil, role: nil}

      conn = post(conn, Routes.user_path(conn, :create), user: invalid_attrs)

      assert html_response(conn, 200) =~ "New User"
    end
  end
end
