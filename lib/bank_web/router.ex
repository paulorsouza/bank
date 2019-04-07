defmodule BankWeb.Router do
  use BankWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BankWeb.Auth.Plug.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BankWeb do
    pipe_through :browser

    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    get "/", PageController, :index
  end

  scope "/authenticated", BankWeb do
    pipe_through [:browser, :ensure_authentication]

    resources "/wallets", WalletController, only: [:show], singleton: true
    resources "/withdraws", WithdrawController, only: [:new, :create]
    resources "/transfers", TransferController, only: [:new, :create, :index]
    get "/balances/:period", BalanceController, :index
  end

  scope "/api/v1", BankWeb do
    pipe_through :api

    resources "/users", Api.UserController, only: [:create], as: :user_api
  end
end
