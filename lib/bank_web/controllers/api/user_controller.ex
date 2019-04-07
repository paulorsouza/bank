defmodule BankWeb.Api.UserController do
  use BankWeb, :controller

  alias Bank.Credentials

  action_fallback(BankWeb.Api.FallbackController)

  def create(conn, user) do
    with user <- Map.put(user, "password_confirmation", user["password"]),
         {:ok, user} <- Credentials.create_user(user) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end
end
