defmodule BankWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for building error messages.
  """

  use Phoenix.HTML

  def error_tag(nil, _field), do: nil
  def error_tag(true, _field), do: nil
  def error_tag(errors, _field) when is_binary(errors), do: nil

  def error_tag(errors, field) do
    Enum.map(Map.get(errors, field, []), fn error ->
      content_tag(:span, error, class: "help-block")
    end)
  end
end
