defmodule Bank.Accounts.Aggregates.Wallet do
  @moduledoc false

  defstruct [
    :uuid,
    :user_uuid,
    :username,
    :balance
  ]

  alias __MODULE__
  alias Bank.Accounts.Events.{WalletOpened, Withdrawn, Deposited, MoneySent, MoneyReceived}
  alias Bank.Accounts.Commands.{OpenWallet, Withdraw, Deposit, SendMoney, ReceiveMoney}

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

  def execute(%Wallet{uuid: nil}, %Withdraw{}), do: {:error, :wallet_not_found}
  def execute(%Wallet{uuid: nil}, %Deposit{}), do: {:error, :wallet_not_found}
  def execute(%Wallet{uuid: nil}, %MoneySent{}), do: {:error, :wallet_not_found}
  def execute(%Wallet{uuid: nil}, %ReceiveMoney{}), do: {:error, :wallet_not_found}

  def execute(%Wallet{balance: balance}, %Withdraw{amount: amount})
      when amount > balance,
      do: {:error, :insufficient_funds}

  def execute(%Wallet{balance: balance}, %SendMoney{amount: amount})
      when amount > balance,
      do: {:error, :insufficient_funds}

  def execute(%Wallet{} = wallet, %Withdraw{} = command) do
    %Withdrawn{
      wallet_uuid: wallet.uuid,
      amount: command.amount,
      operation_date: command.operation_date,
      new_balance: wallet.balance - command.amount
    }
  end

  def execute(%Wallet{} = wallet, %Deposit{} = command) do
    %Deposited{
      wallet_uuid: wallet.uuid,
      amount: command.amount,
      operation_date: command.operation_date,
      new_balance: wallet.balance + command.amount
    }
  end

  def execute(%Wallet{} = wallet, %SendMoney{} = command) do
    %MoneySent{
      transfer_uuid: command.transfer_uuid,
      wallet_uuid: wallet.uuid,
      to_wallet_uuid: command.to_wallet_uuid,
      amount: command.amount,
      operation_date: command.operation_date,
      new_balance: wallet.balance - command.amount
    }
  end

  def execute(%Wallet{} = wallet, %ReceiveMoney{} = command) do
    %MoneyReceived{
      transfer_uuid: command.transfer_uuid,
      wallet_uuid: command.wallet_uuid,
      from_wallet_uuid: command.from_wallet_uuid,
      amount: command.amount,
      operation_date: command.operation_date,
      new_balance: wallet.balance + command.amount
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

  def apply(%Wallet{} = w, %Withdrawn{} = e), do: balance(w, e)
  def apply(%Wallet{} = w, %MoneySent{} = e), do: balance(w, e)
  def apply(%Wallet{} = w, %Deposited{} = e), do: balance(w, e)
  def apply(%Wallet{} = w, %MoneyReceived{} = e), do: balance(w, e)

  defp balance(wallet, event), do: %Wallet{wallet | balance: event.new_balance}
end
