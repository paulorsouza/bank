defmodule Bank.Accounts do
  @moduledoc """
  The boundary for the Bank Accounts.
  """

  alias Bank.Accounts.Commands.OpenWallet
  alias Bank.Accounts.Projections.Wallet
  alias Bank.Router

  def open_wallet(%{user_uuid: uuid} = attrs) do
    uuid = UUID.uuid4()

    open_wallet =
      attrs
      |> OpenWallet.new()
      |> OpenWallet.assign_uuid(uuid)

    with :ok <- Router.dispatch(open_wallet, consistency: :strong) do
      get(Wallet, uuid)
    end
  end

  # ReadStore
  import Ecto.Query
  alias Bank.Repo

  def get_wallet_by_user_uuid(user_uuid) do
    Repo.get_by(Wallet, user_uuid: user_uuid)
  end

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
