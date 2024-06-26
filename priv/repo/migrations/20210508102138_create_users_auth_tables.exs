defmodule Jalka2022.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :name, :citext, null: false
      add :email, :citext
      add :hashed_password, :string, null: false
      add(:group_score, :integer, default: 0)
      add(:playoff_score, :integer, default: 0)
      add(:confirmed_at, :naive_datetime)

      timestamps()
    end

    create unique_index(:users, [:name])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end
