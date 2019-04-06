defmodule Bank.Repo.Migrations.CreateOperations do
  use Ecto.Migration

  def change do
    create table(:operations, primary_key: false) do
      add :wallet_uuid, :binary_id, null: false
      add :type, :integer, null: false
      add :amount, :float, null: false
      add :operation_date, :timestamptz
      add :from_user, :string, default: ""
      add :to_user, :string, default: ""

      timestamps()
    end
  end
end
