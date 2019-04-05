defmodule Bank.Accounts.Projectors.Wallet do
  @moduledoc false

  use Commanded.Projections.Ecto,
    name: "Accounts.Projectors.Wallet",
    consistency: :strong

  alias Bank.Accounts.Events.WalletOpened
  alias Bank.Accounts.Projections.Wallet

  project(%WalletOpened{} = created, fn multi ->
    Ecto.Multi.insert(multi, :user, %Wallet{
      uuid: created.wallet_uuid,
      user_uuid: created.user_uuid,
      username: created.username,
      balance: created.balance
    })
  end)
end
