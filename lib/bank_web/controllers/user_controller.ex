defmodule BankWeb.UserController do
  use BankWeb, :controller

  alias Bank.Credentials

  def new(conn, _params) do
    render(conn, "new.html", errors: nil)
  end

  def create(conn, user_params) do
    case Credentials.create_user(user_params) do
      {:ok, user} ->
        conn
        |> BankWeb.Auth.login(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, :validation_failure, errors} ->
        render(conn, "new.html", errors: errors)

      _ ->
        render(conn, "new.html", errors: true)
    end
  end
end
