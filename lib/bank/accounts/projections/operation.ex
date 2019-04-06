defmodule Bank.Accounts.Projections.Operation do
  @moduledoc false

  use Ecto.Schema

  @primary_key false
  schema "operations" do
    field :wallet_uuid, :binary_id
    field :operation_date, :utc_datetime_usec
    field :amount, :float
    field :type, OperationsType
    field :from_user, :string, default: ""
    field :to_user, :string, default: ""

    timestamps()
  end
end
