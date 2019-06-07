defmodule Backend.Repo.Migrations.CreateUserGoals do
  use Ecto.Migration

  def change do
    create table(:user_goals) do
      add :month, :integer
      add :year, :integer
      add :amount, :integer

      timestamps()
    end

  end
end
