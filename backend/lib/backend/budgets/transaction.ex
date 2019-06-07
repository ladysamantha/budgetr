defmodule Backend.Budgets.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :integer
    field :category, :string
    field :datetime_occurred, :utc_datetime
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:datetime_occurred, :amount, :description, :category])
    |> validate_required([:datetime_occurred, :amount, :description, :category])
  end
end
