defmodule BankWeb.SessionController do
  use BankWeb, :controller

  alias Bank.Credentials

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"credential" => credential, "password" => pass}}) do
    user = Credentials.get_user_by_user_or_email(credential)

    if Credentials.Auth.valid_password?(user, pass) do
      conn
      |> BankWeb.Auth.login(user)
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
    |> BankWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
