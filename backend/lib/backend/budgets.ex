defmodule Backend.Budgets do
  @moduledoc """
  The Budgets context.
  """

  import Ecto.Query, warn: false
  require Ecto.Query
  alias Backend.Repo

  alias Backend.Budgets.Transaction

  @doc """
  """
  def list_transactions(user_id) do
    shift = Timex.shift(Timex.now(), days: -30)
    from(t in Transaction, where: t.user_id == ^user_id, where: t.datetime_occurred > ^shift, order_by: [desc: t.datetime_occurred]) |> Repo.all
  end

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Bulk uploads transactions from a CSV file

  The file location will be created by Phx/Plug

  ## Note
  Due to the nature of [insert_all/3](https://hexdocs.pm/ecto/Ecto.Repo.html#c:insert_all/3) the timestamp columns need to be generated manually
  """
  def bulk_create_transactions(csv_file) do
    txs = csv_file
          |> File.stream!
          |> CSV.decode(headers: true)
          |> Enum.filter(fn {result, _} -> result == :ok end)
          |> Enum.map(fn {:ok, data} -> data end)
          |> Enum.map(fn %{"user_id" => user_id} = tx -> %{tx | "user_id" => String.to_integer(user_id)} end)
          |> Enum.map(fn %{"amount" => amt} = tx -> %{tx | "amount" => String.to_integer(amt)} end)
          |> Enum.map(fn %{"datetime_occurred" => dt} = tx -> %{tx | "datetime_occurred" => DateTime.from_iso8601(dt) |> elem(1) |> DateTime.truncate(:second)} end)
          |> Enum.map(fn tx -> Map.put(tx, "inserted_at", NaiveDateTime.utc_now |> NaiveDateTime.truncate(:second)) end)
          |> Enum.map(fn tx -> Map.put(tx, "updated_at", NaiveDateTime.utc_now |> NaiveDateTime.truncate(:second)) end)
          |> Enum.map(fn tx -> Map.new(tx, fn {k, v} -> {String.to_atom(k), v} end) end)
    Repo.insert_all(Transaction, txs)
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{source: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end

  alias Backend.Budgets.Goal

  @doc """
  Returns the list of user_goals.

  ## Examples

      iex> list_user_goals()
      [%Goal{}, ...]

  """
  def list_user_goals do
    Repo.all(Goal)
  end

  @doc """
  Gets a single goal.

  Raises `Ecto.NoResultsError` if the Goal does not exist.

  ## Examples

      iex> get_goal!(123)
      %Goal{}

      iex> get_goal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_goal!(id), do: Repo.get!(Goal, id)

  @doc """
  Creates a goal.

  ## Examples

      iex> create_goal(%{field: value})
      {:ok, %Goal{}}

      iex> create_goal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_goal(attrs \\ %{}) do
    %Goal{}
    |> Goal.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a goal.

  ## Examples

      iex> update_goal(goal, %{field: new_value})
      {:ok, %Goal{}}

      iex> update_goal(goal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_goal(%Goal{} = goal, attrs) do
    goal
    |> Goal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Goal.

  ## Examples

      iex> delete_goal(goal)
      {:ok, %Goal{}}

      iex> delete_goal(goal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_goal(%Goal{} = goal) do
    Repo.delete(goal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking goal changes.

  ## Examples

      iex> change_goal(goal)
      %Ecto.Changeset{source: %Goal{}}

  """
  def change_goal(%Goal{} = goal) do
    Goal.changeset(goal, %{})
  end
end
