defmodule Bank.Accounts.Events.Withdrawn do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [
    :wallet_uuid,
    :amount
  ]
end
