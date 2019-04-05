defmodule Bank.Accounts.Commands.OpenWallet do
  @moduledoc false

  defstruct [
    :wallet_uuid,
    :user_uuid,
    :username,
    :balance
  ]

  use ExConstructor
  use Vex.Struct

  alias __MODULE__

  validates(:wallet_uuid, uuid: true)
  validates(:user_uuid, uuid: true)
  validates(:balance, float: true)

  def assign_uuid(%OpenWallet{} = open_wallet, uuid) do
    %OpenWallet{open_wallet | wallet_uuid: uuid}
  end
end
