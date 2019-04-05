defmodule Bank.Accounts.Aggregates.Wallet do
  @moduledoc false

  defstruct [
    :uuid,
    :user_uuid,
    :username,
    :balance
  ]

  alias __MODULE__
  alias Bank.Accounts.Events.WalletOpened
  alias Bank.Accounts.Commands.OpenWallet

  @doc """
  Open a wallet linked with user
  """
  def execute(%Wallet{uuid: nil}, %OpenWallet{} = create) do
    %WalletOpened{
      wallet_uuid: create.wallet_uuid,
      user_uuid: create.user_uuid,
      username: create.username,
      balance: create.balance
    }
  end

  def apply(%Wallet{} = wallet, %WalletOpened{} = created) do
    %Wallet{
      wallet
      | uuid: created.wallet_uuid,
        user_uuid: created.user_uuid,
        username: created.username,
        balance: created.balance
    }
  end
end
