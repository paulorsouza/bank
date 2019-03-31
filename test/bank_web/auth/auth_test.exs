defmodule BankWeb.AuthTest do
  use BankWeb.ConnCase
  import Bank.Factory

  alias BankWeb.Auth

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(BankWeb.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "login puts the user in the session", %{conn: conn} do
    user = insert(:user)

    login_conn =
      conn
      |> Auth.login(user)
      |> send_resp(:ok, "")

    next_conn = get(login_conn, "/")
    assert get_session(next_conn, :user_id) == user.id
  end

  test "logout drops the session", %{conn: conn} do
    logout_conn =
      conn
      |> put_session(:user_id, 123)
      |> Auth.logout()
      |> send_resp(:ok, "")

    next_conn = get(logout_conn, "/")
    refute get_session(next_conn, :user_id)
  end

  describe "plug current_user" do
    alias BankWeb.Auth.Plug.CurrentUser

    test "ensure_authentication halts when no current_user exists", %{conn: conn} do
      conn = CurrentUser.ensure_authentication(conn, [])
      assert conn.halted
    end

    test "ensure_authentication continues when the current_user exists", %{conn: conn} do
      conn =
        conn
        |> assign(:current_user, %Bank.Accounts.User{})
        |> CurrentUser.ensure_authentication([])

      refute conn.halted
    end

    test "call places user from session into assigns", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> put_session(:user_id, user.id)
        |> CurrentUser.call(CurrentUser.init([]))

      assert conn.assigns.current_user.id == user.id
    end

    test "call with no session sets current_user assign to nil", %{conn: conn} do
      conn = CurrentUser.call(conn, CurrentUser.init([]))
      assert conn.assigns.current_user == nil
    end
  end
end
