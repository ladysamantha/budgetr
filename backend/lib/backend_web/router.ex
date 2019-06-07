defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BackendWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/transactions", TransactionController, except: [:new, :edit]
    resources "/goals", GoalController, except: [:new, :edit]
  end
end
