defmodule BankWeb.PageControllerTest do
  use BankWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "PRS Bank"
  end
end
