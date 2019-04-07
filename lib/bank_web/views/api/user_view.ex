defmodule BankWeb.Api.UserView do
  use BankWeb, :view

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      username: user.username,
      email: user.email
    }
  end
end
