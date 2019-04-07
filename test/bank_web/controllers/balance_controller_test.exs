defmodule BankWeb.BalanceControllerTest do
  use BankWeb.ConnCase
  @moduletag :web

  describe "transfer form" do
    @tag :logged_in
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.balance_path(conn, :index, "total"))

      assert html_response(conn, 200) =~ "Balance"
    end
  end
end
