defmodule BankWeb.Utils do
  @moduledoc false

  use Phoenix.HTML
  alias Bank.Support.Utils

  def to_real(amount), do: Utils.Float.to_real(amount)
end
