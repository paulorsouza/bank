defmodule BankWeb.BalanceController do
  use BankWeb, :controller

  alias Bank.Accounts
  alias Bank.Accounts.Projections.Wallet

  def index(conn, %{"period" => period}) do
    %Wallet{uuid: uuid} = get_wallet(conn)

    balance =
      case period do
        "total" -> Accounts.get_balance(uuid)
        period -> Accounts.get_balance_per_period(uuid, period)
      end

    render(conn, "index.html", balance: balance)
  end
end
