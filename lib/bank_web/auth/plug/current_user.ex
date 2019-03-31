defmodule BankWeb.Auth.Plug.CurrentUser do
  @moduledoc """
  This plug first verify if the current user is in conn's assign,
  if it does not, then this plug verify if has a user in session and if it is user
  is valid then assign this user in conn.
  If in none of the steps the user is found the current user is assign as nil.
  If the current_user is nill the conn will be redirect to home page.
  """

  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias BankWeb.Router.Helpers, as: Routes
  alias Bank.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    assign_current_user(conn)
  end

  defp assign_current_user(conn) do
    user_id = get_session(conn, :user_id)

    cond do
      conn.assigns[:current_user] ->
        conn

      user = user_id && Accounts.get_user(user_id) ->
        assign(conn, :current_user, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def ensure_authentication(conn, _otps) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
