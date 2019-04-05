defmodule BankWeb.WalletController do
  use BankWeb, :controller

  alias Bank.Accounts

  def show(conn, _params) do
    wallet =
      conn
      |> get_session(:user_id)
      |> Accounts.get_wallet_by_user_uuid()

    render(conn, "show.html", balance: wallet.balance)
  end
end
