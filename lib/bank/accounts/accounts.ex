defmodule Bank.Accounts do
  @moduledoc """
  The boundary for the Bank Accounts.
  """

  alias Bank.Accounts.Commands.{
    OpenWallet,
    Withdraw,
    Deposit,
    SendMoney
  }

  alias Bank.Accounts.Projections.Wallet
  alias Bank.Router

  def open_wallet(attrs \\ %{}) do
    uuid = UUID.uuid4()

    open_wallet =
      attrs
      |> OpenWallet.new()
      |> OpenWallet.assign_uuid(uuid)

    with :ok <- Router.dispatch(open_wallet, consistency: :strong) do
      get(Wallet, uuid)
    end
  end

  def withdraw(wallet_uuid, amount, operation_date \\ Timex.now()) do
    command =
      Withdraw.new(
        wallet_uuid: wallet_uuid,
        amount: amount,
        operation_date: operation_date
      )

    with :ok <- Router.dispatch(command, consistency: :strong) do
      get(Wallet, wallet_uuid)
    end
  end

  def deposit(wallet_uuid, amount, operation_date \\ Timex.now()) do
    command =
      Deposit.new(
        wallet_uuid: wallet_uuid,
        amount: amount,
        operation_date: operation_date
      )

    with :ok <- Router.dispatch(command, consistency: :strong) do
      get(Wallet, wallet_uuid)
    end
  end

  def send_money(wallet_uuid, to_wallet, amount) do
    command =
      SendMoney.new(
        transfer_uuid: UUID.uuid4(),
        wallet_uuid: wallet_uuid,
        to_wallet_uuid: to_wallet,
        amount: amount,
        operation_date: Timex.now()
      )

    with :ok <- Router.dispatch(command, consistency: :strong) do
      get(Wallet, wallet_uuid)
    end
  end

  # ReadStore
  alias Bank.Repo

  def get_wallet(uuid), do: Repo.get(Wallet, uuid)

  def get_wallet_by_user_uuid(user_uuid) do
    Repo.get_by(Wallet, user_uuid: user_uuid)
  end

  def get_wallet_by_user_name(username) do
    case Repo.get_by(Wallet, username: username) do
      nil -> {:error, :wallet_not_found}
      wallet -> {:ok, wallet}
    end
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
