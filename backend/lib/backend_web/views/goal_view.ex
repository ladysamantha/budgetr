defmodule BackendWeb.GoalView do
  use BackendWeb, :view
  alias BackendWeb.GoalView

  def render("index.json", %{user_goals: user_goals}) do
    %{data: render_many(user_goals, GoalView, "goal.json")}
  end

  def render("show.json", %{goal: goal}) do
    %{data: render_one(goal, GoalView, "goal.json")}
  end

  def render("goal.json", %{goal: goal}) do
    %{id: goal.id,
      month: goal.month,
      year: goal.year,
      amount: goal.amount}
  end
end
