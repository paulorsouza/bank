defmodule BankWeb.WithdrawController do
  use BankWeb, :controller

  alias Bank.Accounts

  def new(conn, _params) do
    render(conn, "new.html", errors: nil)
  end

  def create(conn, %{"amount" => value}) do
    wallet = get_wallet(conn)
    amount = Utils.Float.from_input(value)

    case Accounts.withdraw(wallet.uuid, amount) do
      {:ok, _wallet} ->
        conn
        |> put_flash(:info, "Successful withdrawal")
        |> redirect(to: Routes.wallet_path(conn, :show))

      {:error, :validation_failure, errors} ->
        render(conn, "new.html", errors: errors)

      {:error, :insufficient_funds} ->
        render(conn, "new.html", errors: "Insufficient_founds")

      _ ->
        render(conn, "new.html", errors: true)
    end
  end
end
