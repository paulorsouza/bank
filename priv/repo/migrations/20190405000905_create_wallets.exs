defmodule Bank.Repo.Migrations.CreateWallets do
  use Ecto.Migration

  def change do
    create table(:wallets, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :user_uuid, :binary_id, null: false
      add :username, :string, null: false
      add :balance, :numeric, null: false

      timestamps()
    end
  end
end
