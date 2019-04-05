defmodule Bank.Accounts.Commands.Withdraw do
  @moduledoc false

  defstruct [
    :wallet_uuid,
    :amount
  ]

  use ExConstructor
  use Vex.Struct

  validates(:wallet_uuid, uuid: true)
  validates(:amount, float: true)
end