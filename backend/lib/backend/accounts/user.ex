defmodule Backend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :external_id, :string
    field :first_name, :string
    field :last_name, :string
    has_many :transactions, Backend.Budgets.Transaction

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :external_id])
    |> validate_required([:first_name, :last_name, :email, :external_id])
  end
end
