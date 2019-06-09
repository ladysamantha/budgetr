defmodule BackendWeb.TransactionView do
  use BackendWeb, :view
  alias BackendWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{id: transaction.id,
      datetime_occurred: transaction.datetime_occurred,
      amount: transaction.amount,
      description: transaction.description,
      category: transaction.category}
  end

  def render("bulk.json", %{num_created: num}) do
    %{transactions_created: num}
  end
end
