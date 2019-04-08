defmodule Bank.Accounts.Commands.SendMoney do
  @moduledoc false

  defstruct transfer_uuid: nil,
            wallet_uuid: nil,
            to_wallet_uuid: nil,
            amount: nil,
            operation_date: nil

  use ExConstructor
  use Vex.Struct

  validates(:transfer_uuid, uuid: true)
  validates(:wallet_uuid, uuid: true)
  validates(:to_wallet_uuid, uuid: true)
  validates(:amount, float: true)
end
