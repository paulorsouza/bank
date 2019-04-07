defmodule BankWeb.TransferController do
  use BankWeb, :controller

  alias Bank.Accounts
  alias Bank.Accounts.Projections.Wallet

  def new(conn, _params) do
    render(conn, "new.html", errors: nil)
  end

  def index(conn, _params) do
    with %Wallet{uuid: uuid} <- get_wallet(conn),
         operations when is_list(operations) <- Accounts.list_operations(uuid) do
      render(conn, "index.html", operations: operations)
    else
      _ ->
        render(conn, "index.html", operations: [])
    end
  end

  def create(conn, %{"username" => username, "amount" => value}) do
    with %Wallet{uuid: uuid} <- get_wallet(conn),
         {:ok, %Wallet{uuid: to_wallet_uuid}} <- Accounts.get_wallet_by_user_name(username),
         amount when is_float(amount) <- Utils.Float.from_input(value),
         {:ok, _walllet} <- Accounts.send_money(uuid, to_wallet_uuid, amount) do
      conn
      |> put_flash(:info, "Successful transfer")
      |> redirect(to: Routes.wallet_path(conn, :show))
    else
      {:error, :validation_failure, errors} ->
        render(conn, "new.html", errors: errors)

      {:error, :insufficient_funds} ->
        render(conn, "new.html", errors: "Insufficient_founds")

      {:error, :wallet_not_found} ->
        render(conn, "new.html", errors: "Wallet not found")

      _ ->
        render(conn, "new.html", errors: true)
    end
  end
end
