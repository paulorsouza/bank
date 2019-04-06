defmodule Bank.Accounts.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        Bank.Accounts.Projectors.Wallet,
        Bank.Accounts.Workflows.OpenWalletFromUser,
        Bank.Accounts.ProcessManagers.Transfer
      ],
      strategy: :one_for_one
    )
  end
end
