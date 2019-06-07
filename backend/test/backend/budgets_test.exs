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

  describe "user_goals" do
    alias Backend.Budgets.Goal

    @valid_attrs %{amount: 42, month: 42, year: 42}
    @update_attrs %{amount: 43, month: 43, year: 43}
    @invalid_attrs %{amount: nil, month: nil, year: nil}

    def goal_fixture(attrs \\ %{}) do
      {:ok, goal} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Budgets.create_goal()

      goal
    end

    test "list_user_goals/0 returns all user_goals" do
      goal = goal_fixture()
      assert Budgets.list_user_goals() == [goal]
    end

    test "get_goal!/1 returns the goal with given id" do
      goal = goal_fixture()
      assert Budgets.get_goal!(goal.id) == goal
    end

    test "create_goal/1 with valid data creates a goal" do
      assert {:ok, %Goal{} = goal} = Budgets.create_goal(@valid_attrs)
      assert goal.amount == 42
      assert goal.month == 42
      assert goal.year == 42
    end

    test "create_goal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Budgets.create_goal(@invalid_attrs)
    end

    test "update_goal/2 with valid data updates the goal" do
      goal = goal_fixture()
      assert {:ok, %Goal{} = goal} = Budgets.update_goal(goal, @update_attrs)
      assert goal.amount == 43
      assert goal.month == 43
      assert goal.year == 43
    end

    test "update_goal/2 with invalid data returns error changeset" do
      goal = goal_fixture()
      assert {:error, %Ecto.Changeset{}} = Budgets.update_goal(goal, @invalid_attrs)
      assert goal == Budgets.get_goal!(goal.id)
    end

    test "delete_goal/1 deletes the goal" do
      goal = goal_fixture()
      assert {:ok, %Goal{}} = Budgets.delete_goal(goal)
      assert_raise Ecto.NoResultsError, fn -> Budgets.get_goal!(goal.id) end
    end

    test "change_goal/1 returns a goal changeset" do
      goal = goal_fixture()
      assert %Ecto.Changeset{} = Budgets.change_goal(goal)
    end
  end
end
