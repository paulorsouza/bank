defmodule Bank.Support.Utils.FloatTest do
  use ExUnit.Case

  alias Bank.Support.Utils

  test "returns a pretty value with R$" do
    assert "R$ 1000,00" == Utils.Float.to_real(1000.00)
    assert "R$ 1000,20" == Utils.Float.to_real(1000.2)
    assert "R$ 1000,02" == Utils.Float.to_real(1000.020000)
  end

  test "returns a float from input value" do
    assert 1000.00 == Utils.Float.from_input("1000,000")
    assert 1000.00 == Utils.Float.from_input("1000")
    assert 1000.00 == Utils.Float.from_input("1000,0")
  end
end
