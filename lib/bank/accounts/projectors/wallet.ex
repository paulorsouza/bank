defmodule Bank.Accounts.Projectors.Wallet do
  @moduledoc false
  use Commanded.Projections.Ecto,
    name: "Accounts.Projectors.Wallet",
    consistency: :strong

  import Ecto.Query
  alias Bank.Repo

  alias Bank.Accounts.Events.{
    WalletOpened,
    Withdrawn,
    Deposited,
    MoneySent,
    MoneyReceived
  }

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

  project(%MoneySent{} = event, fn multi ->
    multi
    |> Ecto.Multi.run(:to_user, fn _, _ -> get_user(event.to_wallet_uuid) end)
    |> Ecto.Multi.run(:operation, fn _, %{to_user: to_user} ->
      operation = %Operation{
        wallet_uuid: event.wallet_uuid,
        amount: event.amount,
        operation_date: convert_datetime(event.operation_date),
        type: :send_money,
        to_user: to_user
      }

      Repo.insert(operation)
    end)
    |> Ecto.Multi.update_all(
      :wallet,
      wallet_query(event.wallet_uuid),
      set: [balance: event.new_balance]
    )
  end)

  project(%MoneyReceived{} = event, fn multi ->
    multi
    |> Ecto.Multi.run(:from_user, fn _, _ -> get_user(event.from_wallet_uuid) end)
    |> Ecto.Multi.run(:operation, fn _, %{from_user: from_user} ->
      operation = %Operation{
        wallet_uuid: event.wallet_uuid,
        amount: event.amount,
        operation_date: convert_datetime(event.operation_date),
        type: :receive_money,
        from_user: from_user
      }

      Repo.insert(operation)
    end)
    |> Ecto.Multi.update_all(
      :wallet,
      wallet_query(event.wallet_uuid),
      set: [balance: event.new_balance]
    )
  end)

  defp wallet_query(wallet_uuid) do
    from(w in Wallet, where: w.uuid == ^wallet_uuid)
  end

  defp get_user(wallet_uuid) do
    wallet = Repo.get(Wallet, wallet_uuid)
    {:ok, wallet.username}
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
