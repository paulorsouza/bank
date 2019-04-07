defmodule Bank.Accounts.Commands.Withdraw do
  @moduledoc false

  defstruct transfer_uuid: nil,
            wallet_uuid: nil,
            amount: nil,
            operation_date: nil

  use ExConstructor
  use Vex.Struct

  validates(:wallet_uuid, uuid: true)
  validates(:amount, float: true)
end
