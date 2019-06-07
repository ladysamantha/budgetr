defmodule Backend.Repo.Migrations.SetUserEmailToUnique do
  use Ecto.Migration

  def change do
    create unique_index("users", [:email])
  end

  def drop do
    drop unique_index("users", [:email])
  end
end
