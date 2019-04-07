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

  def call(conn, {:error, :invalid_value}) do
    conn
    |> put_status(400)
    |> put_view(BankWeb.ErrorView)
    |> render(:"400")
  end
end
