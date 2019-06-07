defmodule Backend.Budgets.Goal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_goals" do
    field :amount, :integer
    field :month, :integer
    field :year, :integer

    timestamps()
  end

  @doc false
  def changeset(goal, attrs) do
    goal
    |> cast(attrs, [:month, :year, :amount])
    |> validate_required([:month, :year, :amount])
  end
end
