defmodule BankWeb.SessionControllerTest do
  use BankWeb.ConnCase
  import Bank.Factory

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))

      assert html_response(conn, 200) =~ "Login"
    end
  end

  describe "create session" do
    test "shows welcome message when credential is valid", %{conn: conn} do
      password = Pbkdf2.hash_pwd_salt("12345678")
      user = insert(:user_projection, encrypted_password: password)
      attrs = %{credential: user.email, password: "12345678"}

      conn = post(conn, Routes.session_path(conn, :create), session: attrs)

      assert redirected_to(conn) == Routes.page_path(conn, :index)
      assert get_flash(conn, :info) == "Welcome back!"
    end

    test "shows invalid message when credential is wrong", %{conn: conn} do
      invalid_attrs = %{credential: "invalid", password: "123456"}

      conn = post(conn, Routes.session_path(conn, :create), session: invalid_attrs)

      assert html_response(conn, 200) =~ "Login"
      assert get_flash(conn, :error) == "Invalid email/password"
    end
  end
end
