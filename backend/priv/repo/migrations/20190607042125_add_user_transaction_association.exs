defmodule Backend.Repo.Migrations.AddUserTransactionAssociation do
  use Ecto.Migration

  def change do
    alter table("transactions") do
      add :user_id, references("users")
    end
  end

  def drop do
    remove :user_id
  end
end
