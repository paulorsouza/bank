defmodule Bank.Credentials.Validators.UniqueUsername do
  @moduledoc false

  use Vex.Validator

  alias Bank.Credentials
  alias Bank.Credentials.Projections.User

  def validate(username, context) do
    user_uuid = Map.get(context, :user_uuid)

    case username_registered?(username, user_uuid) do
      true -> {:error, "has already been taken"}
      false -> :ok
    end
  end

  defp username_registered?(username, user_uuid) do
    case Credentials.get_user_by_username(username) do
      %User{uuid: ^user_uuid} -> false
      nil -> false
      _ -> true
    end
  end
end
