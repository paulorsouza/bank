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
    pipe_through [:api]

    resources "/users", Api.UserController, only: [:create], as: :user_api
  end

  scope "/api/v1", BankWeb do
    pipe_through [:api, :validate_credentials]

    resources "/withdraws", Api.WithdrawController, only: [:create], as: :withdraw_api
    resources "/wallets", Api.WalletController, only: [:show], singleton: true, as: :wallet_api
    resources "/transfers", Api.TransferController, only: [:create], as: :transfer_api
    resources "/balances", Api.BalanceController, only: [:index], as: :balance_api
  end

  # Rollbax
  # https://hexdocs.pm/rollbax/using-rollbax-in-plug-based-applications.html
  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    conn = Plug.Conn.fetch_query_params(conn)

    conn_data = %{
      "request" => %{
        "url" => "#{conn.scheme}://#{conn.host}:#{conn.port}#{conn.request_path}",
        "user_ip" => conn.remote_ip |> Tuple.to_list() |> Enum.join("."),
        "headers" => Enum.into(conn.req_headers, %{}),
        "params" => conn.params,
        "method" => conn.method
      }
    }

    Rollbax.report(kind, reason, stacktrace, %{}, conn_data)
  end
end
