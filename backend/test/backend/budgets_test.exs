defmodule Backend.BudgetsTest do
  use Backend.DataCase

  alias Backend.Budgets

  describe "transactions" do
    alias Backend.Budgets.Transaction

    @valid_attrs %{amount: 42, category: "some category", datetime_occurred: "2010-04-17T14:00:00Z", description: "some description"}
    @update_attrs %{amount: 43, category: "some updated category", datetime_occurred: "2011-05-18T15:01:01Z", description: "some updated description"}
    @invalid_attrs %{amount: nil, category: nil, datetime_occurred: nil, description: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Budgets.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Budgets.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Budgets.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Budgets.create_transaction(@valid_attrs)
      assert transaction.amount == 42
      assert transaction.category == "some category"
      assert transaction.datetime_occurred == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert transaction.description == "some description"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Budgets.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = Budgets.update_transaction(transaction, @update_attrs)
      assert transaction.amount == 43
      assert transaction.category == "some updated category"
      assert transaction.datetime_occurred == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert transaction.description == "some updated description"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Budgets.update_transaction(transaction, @invalid_attrs)
      assert transaction == Budgets.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Budgets.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Budgets.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Budgets.change_transaction(transaction)
    end
  end
end
