defmodule BankWeb.WalletController do
  use BankWeb, :controller

  alias Bank.Accounts

  def show(conn, _params) do
    wallet = get_wallet(conn)

    render(conn, "show.html", balance: wallet.balance)
  end
end
