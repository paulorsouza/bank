defmodule Bank.Credentials.Validators.UniqueEmail do
  @moduledoc false

  use Vex.Validator

  alias Bank.Credentials
  alias Bank.Credentials.Projections.User

  def validate(value, context) do
    user_uuid = Map.get(context, :user_uuid)

    case email_registered?(value, user_uuid) do
      true -> {:error, "has already been taken"}
      false -> :ok
    end
  end

  defp email_registered?(email, user_uuid) do
    case Credentials.get_user_by_email(email) do
      %User{uuid: ^user_uuid} -> false
      nil -> false
      _ -> true
    end
  end
end
