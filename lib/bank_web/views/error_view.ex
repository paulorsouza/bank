defmodule BankWeb.ErrorView do
  use BankWeb, :view

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end

  def render("400.json", _assings) do
    %{errors: %{detail: "Bad Request"}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "Page not found"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end

  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
