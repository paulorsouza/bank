defmodule BankWeb.TransferControllerTest do
  use BankWeb.ConnCase
  @moduletag :web

  describe "transfer form" do
    @tag :logged_in
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.transfer_path(conn, :new))

      assert html_response(conn, 200) =~ "Transfer"
    end
  end
end
