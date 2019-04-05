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
  end

  # Other scopes may use custom stacks.
  # scope "/api", BankWeb do
  #   pipe_through :api
  # end
end
