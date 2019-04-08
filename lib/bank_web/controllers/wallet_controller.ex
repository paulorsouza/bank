defmodule BankWeb.WalletController do
  use BankWeb, :controller

  def show(conn, _params) do
    wallet = get_wallet(conn)

    render(conn, "show.html", balance: wallet.balance)
  end
end
