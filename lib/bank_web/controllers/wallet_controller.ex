defmodule BankWeb.WalletController do
  use BankWeb, :controller

  alias Bank.Accounts

  def show(conn, _params) do
    wallet = get_wallet(conn)
    balance = Utils.Float.to_real(wallet.balance)

    render(conn, "show.html", balance: balance)
  end
end
