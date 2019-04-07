defmodule Bank.Support.Utils.Float do
  @moduledoc """
  A lazy way to treat currency :D
  """

  def to_real(float) do
    float
    |> :erlang.float_to_binary(decimals: 2)
    |> String.replace(".", ",")
    |> String.replace_prefix("", "R$ ")
  end

  def from_input(""), do: 0.00

  def from_input(string) when is_binary(string) do
    try do
      {float, _} =
        string
        |> String.replace(",", ".")
        |> Float.parse()

      Float.ceil(float, 2)
    rescue
      _ -> {:error, :invalid_value}
    end
  end
end
