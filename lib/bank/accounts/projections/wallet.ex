defmodule Bank.Accounts.Projections.Wallet do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}
  schema "wallets" do
    field :user_uuid, :binary_id
    field :username, :string
    field :balance, :decimal

    timestamps()
  end
end
