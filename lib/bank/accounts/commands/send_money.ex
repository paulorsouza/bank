defmodule Bank.Accounts.Commands.SendMoney do
  @moduledoc false

  defstruct [
    :transfer_uuid,
    :wallet_uuid,
    :to_wallet_uuid,
    :amount,
    :operation_date
  ]

  use ExConstructor
  use Vex.Struct

  alias __MODULE__

  validates(:transfer_uuid, uuid: true)
  validates(:wallet_uuid, uuid: true)
  validates(:to_wallet_uuid, uuid: true)
  validates(:amount, float: true)
end
