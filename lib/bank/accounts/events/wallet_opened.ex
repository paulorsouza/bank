defmodule Bank.Accounts.Events.WalletOpened do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [
    :wallet_uuid,
    :user_uuid,
    :username,
    :balance
  ]
end
