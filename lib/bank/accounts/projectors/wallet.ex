defmodule Bank.Accounts.Projectors.Wallet do
  @moduledoc false
  use Commanded.Projections.Ecto,
    name: "Accounts.Projectors.Wallet",
    consistency: :strong

  import Ecto.Query

  alias Bank.Accounts.Events.{WalletOpened, Withdrawn, Deposited}
  alias Bank.Accounts.Projections.{Wallet, Operation}

  project(%WalletOpened{} = event, fn multi ->
    Ecto.Multi.insert(multi, :wallet, %Wallet{
      uuid: event.wallet_uuid,
      user_uuid: event.user_uuid,
      username: event.username,
      balance: event.balance
    })
  end)

  project(%Withdrawn{} = event, fn multi ->
    multi
    |> Ecto.Multi.insert(:operation, %Operation{
      wallet_uuid: event.wallet_uuid,
      amount: event.amount,
      operation_date: convert_datetime(event.operation_date),
      type: :withdraw
    })
    |> Ecto.Multi.update_all(
      :wallet,
      wallet_query(event.wallet_uuid),
      set: [balance: event.new_balance]
    )
  end)

  project(%Deposited{} = event, fn multi ->
    multi
    |> Ecto.Multi.insert(:operation, %Operation{
      wallet_uuid: event.wallet_uuid,
      amount: event.amount,
      operation_date: convert_datetime(event.operation_date),
      type: :deposit
    })
    |> Ecto.Multi.update_all(
      :wallet,
      wallet_query(event.wallet_uuid),
      set: [balance: event.new_balance]
    )
  end)

  defp wallet_query(wallet_uuid) do
    from(w in Wallet, where: w.uuid == ^wallet_uuid)
  end

  defp convert_datetime(nil) do
    Timex.now()
  end

  defp convert_datetime(string) when is_binary(string) do
    {:ok, date} = Timex.parse(string, "{ISO:Extended}")
    date
  end

  defp convert_datetime(date) do
    date
  end
end
