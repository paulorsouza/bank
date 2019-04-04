defmodule Bank.Credentials.Supervisor do
  @moduledoc """
  Receive credentials event then persist in readstore.
  """
  use Supervisor

  alias Bank.Credentials.Projectors.User

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init([User], strategy: :one_for_one)
  end
end
