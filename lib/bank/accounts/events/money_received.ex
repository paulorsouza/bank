defmodule Bank.Accounts.Events.MoneyReceived do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [
    :transfer_uuid,
    :wallet_uuid,
    :from_wallet_uuid,
    :amount,
    :new_balance,
    :operation_date
  ]
end
