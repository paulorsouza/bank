defmodule Bank.Accounts.ProcessManagers.Transfer do
  @moduledoc """
  This process manager works as a bridge between
  the aggregate of user who is transfering the money and
  the agregate of the user that is receiving the money
  """

  use Commanded.ProcessManagers.ProcessManager,
    name: "Accounts.ProcessManager.Transfer",
    router: Bank.Router

  @derive Jason.Encoder
  defstruct []

  alias Bank.Accounts.Commands.ReceiveMoney
  alias Bank.Accounts.Events.{MoneySent, MoneyReceived}

  def interested?(%MoneySent{transfer_uuid: transfer_uuid}) do
    {:start, transfer_uuid}
  end

  def interested?(%MoneyReceived{transfer_uuid: transfer_uuid}) do
    {:stop, transfer_uuid}
  end

  def interseted?(_), do: false

  def handle(_, %MoneySent{} = event) do
    %ReceiveMoney{
      transfer_uuid: event.transfer_uuid,
      wallet_uuid: event.to_wallet_uuid,
      from_wallet_uuid: event.wallet_uuid,
      amount: event.amount,
      operation_date: event.operation_date
    }
  end

  def apply(state, _event), do: state
end
