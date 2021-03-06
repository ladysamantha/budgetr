defmodule BackendWeb.TransactionController do
  use BackendWeb, :controller

  alias Backend.Budgets
  alias Backend.Budgets.Transaction

  action_fallback BackendWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    transactions = Budgets.list_transactions(user_id)
    render(conn, "index.json", transactions: transactions)
  end

  def index(conn, _params) do
    transactions = Budgets.list_transactions()
    render(conn, "index.json", transactions: transactions)
  end

  def create(conn, %{"transactions" => transactions_file}) do
    filepath = transactions_file.path 
    with {num_tx_created, _} <- Budgets.bulk_create_transactions(filepath) do
      conn
      |> put_status(:created)
      |> render("bulk.json", num_created: num_tx_created)
    end
  end

  def create(conn, %{"transaction" => transaction_params}) do
    with {:ok, %Transaction{} = transaction} <- Budgets.create_transaction(transaction_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.transaction_path(conn, :show, transaction))
      |> render("show.json", transaction: transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Budgets.get_transaction!(id)
    render(conn, "show.json", transaction: transaction)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Budgets.get_transaction!(id)

    with {:ok, %Transaction{} = transaction} <- Budgets.update_transaction(transaction, transaction_params) do
      render(conn, "show.json", transaction: transaction)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Budgets.get_transaction!(id)

    with {:ok, %Transaction{}} <- Budgets.delete_transaction(transaction) do
      send_resp(conn, :no_content, "")
    end
  end
end
