defmodule BankWeb.Api.BalanceController do
  use BankWeb, :controller

  alias Bank.Accounts
  alias Bank.Accounts.Projections.Wallet

  action_fallback(BankWeb.Api.FallbackController)

  def index(conn, _params) do
    with user <- conn.assigns[:current_user],
         %Wallet{uuid: uuid} = wallet <- Accounts.get_wallet_by_user_uuid(user.uuid),
         total <- Accounts.get_balance(uuid),
         daily <- Accounts.get_balance_per_period(uuid, "day"),
         monthly <- Accounts.get_balance_per_period(uuid, "month"),
         annual <- Accounts.get_balance_per_period(uuid, "year") do
      conn
      |> put_status(200)
      |> render("index.json", total: total, daily: daily, monthly: monthly, annual: annual)
    end
  end
end
