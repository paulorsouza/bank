defmodule BankWeb.WalletControllerTest do
  use BankWeb.ConnCase
  @moduletag :web

  describe "show wallet" do
    @tag :logged_in
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.wallet_path(conn, :show))

      assert html_response(conn, 200) =~ "Balance: R$ 1000,00"
    end
  end
end
