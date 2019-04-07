defmodule BankWeb.WithdrawControllerTest do
  use BankWeb.ConnCase
  @moduletag :web

  describe "withdraw form" do
    @tag :logged_in
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.withdraw_path(conn, :new))

      assert html_response(conn, 200) =~ "Withdraw"
    end
  end
end
