defmodule Bank.Accounts.Events.MoneySent do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [
    :transfer_uuid,
    :wallet_uuid,
    :amount,
    :to_wallet_uuid,
    :operation_date,
    :new_balance
  ]
end
