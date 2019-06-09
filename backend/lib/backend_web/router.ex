defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BackendWeb do
    pipe_through :api

    resources "/users", UserController do
      resources "/transactions", TransactionController, only: [:index, :create]
    end

    resources "/transactions", TransactionController, except: [:new, :edit]
    post "/transactions/bulk", TransactionController, :create
    resources "/goals", GoalController, except: [:new, :edit]
  end
end
