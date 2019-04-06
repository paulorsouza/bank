defmodule Bank.Accounts.Commands.ReceiveMoney do
  @moduledoc false

  defstruct [
    :transfer_uuid,
    :wallet_uuid,
    :from_wallet_uuid,
    :amount,
    :operation_date
  ]

  use ExConstructor
  use Vex.Struct

  alias __MODULE__

  validates(:wallet_uuid, uuid: true)
  validates(:from_wallet_uuid, uuid: true)
  validates(:amount, float: true)
end
