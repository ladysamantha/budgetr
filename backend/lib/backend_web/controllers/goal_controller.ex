defmodule BackendWeb.GoalController do
  use BackendWeb, :controller

  alias Backend.Budgets
  alias Backend.Budgets.Goal

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    user_goals = Budgets.list_user_goals()
    render(conn, "index.json", user_goals: user_goals)
  end

  def create(conn, %{"goal" => goal_params}) do
    with {:ok, %Goal{} = goal} <- Budgets.create_goal(goal_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.goal_path(conn, :show, goal))
      |> render("show.json", goal: goal)
    end
  end

  def show(conn, %{"id" => id}) do
    goal = Budgets.get_goal!(id)
    render(conn, "show.json", goal: goal)
  end

  def update(conn, %{"id" => id, "goal" => goal_params}) do
    goal = Budgets.get_goal!(id)

    with {:ok, %Goal{} = goal} <- Budgets.update_goal(goal, goal_params) do
      render(conn, "show.json", goal: goal)
    end
  end

  def delete(conn, %{"id" => id}) do
    goal = Budgets.get_goal!(id)

    with {:ok, %Goal{}} <- Budgets.delete_goal(goal) do
      send_resp(conn, :no_content, "")
    end
  end
end
