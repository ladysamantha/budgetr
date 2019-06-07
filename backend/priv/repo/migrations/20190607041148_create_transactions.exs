defmodule Backend.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :datetime_occurred, :utc_datetime
      add :amount, :integer
      add :description, :string
      add :category, :string

      timestamps()
    end

  end
end
