defmodule Bank.Accounts.Events.Deposited do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [
    :wallet_uuid,
    :amount
  ]
end
