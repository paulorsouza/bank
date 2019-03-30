defmodule Bank.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string, null: false
      add :role, :integer, default: 0
      add :encrypted_password, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
