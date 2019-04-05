defmodule Bank.Accounts.Workflows.OpenWalletFromUser do
  @moduledoc false

  use Commanded.Event.Handler,
    name: "Accounts.Workflows.OpenWalletFromUser",
    consistency: :strong

  alias Bank.Accounts
  alias Bank.Credentials.Events.UserCreated

  def handle(%UserCreated{user_uuid: user_uuid, username: username}, _metadata) do
    with {:ok, _author} <-
           Accounts.open_wallet(%{user_uuid: user_uuid, username: username, balance: 1000.00}) do
      :ok
    end
  end
end
