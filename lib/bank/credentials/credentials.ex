defmodule Bank.Credentials do
  @moduledoc """
  The boundary for the Credentials.
  """

  alias Bank.Credentials.Commands.CreateUser
  alias Bank.Credentials.Projections.User
  alias Bank.Router

  def create_user(attrs \\ %{}) do
    uuid = UUID.uuid4()

    create_user =
      attrs
      |> CreateUser.new()
      |> CreateUser.assign_uuid(uuid)
      |> CreateUser.encrypt_password()

    with :ok <- Router.dispatch(create_user, consistency: :strong) do
      get(User, uuid)
    end
  end

  # ReadStore
  import Ecto.Query
  alias Bank.Repo

  @doc """
  Gets a single user by username or email.
  """
  def get_user_by_user_or_email(credential) do
    query =
      from user in User,
        where: user.username == ^credential or user.email == ^credential

    Repo.one(query)
  end

  def get_user_by_email(email), do: Repo.get_by(User, email: email)
  def get_user_by_username(username), do: Repo.get_by(User, username: username)

  def get_user(uuid), do: Repo.get(User, uuid)

  defp get(schema, uuid) do
    case Repo.get(schema, uuid) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end
end
