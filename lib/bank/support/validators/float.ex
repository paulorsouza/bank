defmodule Bank.Support.Validators.Float do
  @moduledoc false
  use Vex.Validator

  def validate(value, _options) do
    Vex.Validators.By.validate(value, function: &Kernel.is_float/1)
  end
end
