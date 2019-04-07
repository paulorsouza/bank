defmodule BankWeb.Api.FallbackController do
  use BankWeb, :controller

  def call(conn, {:error, :validation_failure, errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BankWeb.ErrorView)
    |> render("error.json", errors: errors)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(BankWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :insufficient_funds}) do
    conn
    |> put_status(422)
    |> put_view(BankWeb.ErrorView)
    |> render(:"422", detail: "Insufficient founds")
  end

  def call(conn, {:error, :invalid_value}) do
    conn
    |> put_status(422)
    |> put_view(BankWeb.ErrorView)
    |> render(:"422", detail: "Invalid value")
  end

  def call(conn, {:error, :wallet_not_found}) do
    conn
    |> put_status(422)
    |> put_view(BankWeb.ErrorView)
    |> render(:"422", detail: "Wallet not found")
  end
end
