defmodule BankWeb.SessionController do
  use BankWeb, :controller

  alias Bank.Accounts
  alias BankWeb.Auth

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    user = Accounts.get_user_by_email(email)

    if Accounts.valid_password?(user, pass) do
      conn
      |> Auth.login(user)
      |> put_flash(:info, "Welcome back!")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Invalid email/password")
      |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
