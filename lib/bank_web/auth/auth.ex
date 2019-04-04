defmodule BankWeb.Auth do
  @moduledoc false

  import Plug.Conn

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.uuid)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end
end
