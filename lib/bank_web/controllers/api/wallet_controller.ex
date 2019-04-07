defmodule BankWeb.Api.WalletController do
  use BankWeb, :controller

  alias Bank.Credentials
  alias Bank.Accounts
  alias Bank.Accounts.Projections.Wallet

  action_fallback(BankWeb.Api.FallbackController)

  def show(conn, _params) do
    with user <- conn.assigns[:current_user],
         %Wallet{} = wallet <- Accounts.get_wallet_by_user_uuid(user.uuid) do
      conn
      |> put_status(200)
      |> render("show.json", wallet: wallet)
    end
  end
end
