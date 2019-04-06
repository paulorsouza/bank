defmodule Bank.Accounts.Aggregates.Wallet do
  @moduledoc false

  defstruct [
    :uuid,
    :user_uuid,
    :username,
    :balance
  ]

  alias __MODULE__
  alias Bank.Accounts.Events.{WalletOpened, Withdrawn, Deposited}
  alias Bank.Accounts.Commands.{OpenWallet, Withdraw, Deposit}

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

  def execute(%Wallet{uuid: nil}, %Withdraw{}) do
    {:error, :wallet_not_found}
  end

  def execute(%Wallet{uuid: nil}, %Deposit{}) do
    {:error, :wallet_not_found}
  end

  def execute(%Wallet{balance: balance}, %Withdraw{amount: amount})
      when amount > balance do
    {:error, :insufficient_funds}
  end

  def execute(%Wallet{} = wallet, %Withdraw{} = command) do
    %Withdrawn{
      wallet_uuid: wallet.uuid,
      amount: command.amount
    }
  end

  def execute(%Wallet{} = wallet, %Deposit{} = command) do
    %Deposited{
      wallet_uuid: wallet.uuid,
      amount: command.amount
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

  def apply(%Wallet{} = wallet, %Withdrawn{} = event) do
    %Wallet{wallet | balance: wallet.balance - event.amount}
  end

  def apply(%Wallet{} = wallet, %Deposited{} = event) do
    %Wallet{wallet | balance: wallet.balance + event.amount}
  end
end
