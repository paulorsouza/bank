defmodule BankWeb.Api.WithdrawController do
  use BankWeb, :controller

  alias Bank.Credentials
  alias Bank.Accounts
  alias Bank.Accounts.Projections.Wallet

  action_fallback(BankWeb.Api.FallbackController)

  def create(conn, params) do
    with user <- conn.assigns[:current_user],
         amount when is_float(amount) <- Utils.Float.from_input(params["value"]),
         %Wallet{} = wallet <- Accounts.get_wallet_by_user_uuid(user.uuid),
         {:ok, wallet} <- Accounts.withdraw(wallet.uuid, amount) do
      conn
      |> put_status(200)
      |> put_view(BankWeb.Api.WalletView)
      |> render("show.json", wallet: wallet)
    end
  end
end
