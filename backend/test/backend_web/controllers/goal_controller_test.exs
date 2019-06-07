defmodule BackendWeb.GoalControllerTest do
  use BackendWeb.ConnCase

  alias Backend.Budgets
  alias Backend.Budgets.Goal

  @create_attrs %{
    amount: 42,
    month: 42,
    year: 42
  }
  @update_attrs %{
    amount: 43,
    month: 43,
    year: 43
  }
  @invalid_attrs %{amount: nil, month: nil, year: nil}

  def fixture(:goal) do
    {:ok, goal} = Budgets.create_goal(@create_attrs)
    goal
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user_goals", %{conn: conn} do
      conn = get(conn, Routes.goal_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create goal" do
    test "renders goal when data is valid", %{conn: conn} do
      conn = post(conn, Routes.goal_path(conn, :create), goal: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.goal_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => 42,
               "month" => 42,
               "year" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.goal_path(conn, :create), goal: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update goal" do
    setup [:create_goal]

    test "renders goal when data is valid", %{conn: conn, goal: %Goal{id: id} = goal} do
      conn = put(conn, Routes.goal_path(conn, :update, goal), goal: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.goal_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => 43,
               "month" => 43,
               "year" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, goal: goal} do
      conn = put(conn, Routes.goal_path(conn, :update, goal), goal: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete goal" do
    setup [:create_goal]

    test "deletes chosen goal", %{conn: conn, goal: goal} do
      conn = delete(conn, Routes.goal_path(conn, :delete, goal))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.goal_path(conn, :show, goal))
      end
    end
  end

  defp create_goal(_) do
    goal = fixture(:goal)
    {:ok, goal: goal}
  end
end
