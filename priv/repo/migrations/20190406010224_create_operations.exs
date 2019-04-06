defmodule Bank.Repo.Migrations.CreateOperations do
  use Ecto.Migration

  def change do
    create table(:operations, primary_key: false) do
      add :wallet_uuid, :binary_id, null: false
      add :type, :integer, null: false
      add :amount, :float, null: false
      add :operation_date, :timestamptz

      timestamps()
    end
  end
end
