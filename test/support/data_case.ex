defmodule Bank.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Bank.Repo

      import Ecto
      import Ecto.Query
      import Bank.DataCase

      defp wait(assertation), do: wait(assertation, 5)
      defp wait(assertation, 0), do: assertation.()

      defp wait(assertation, tries) do
        try do
          assertation.()
        rescue
          _ ->
            :timer.sleep(300)
            wait(assertation, tries - 1)
        end
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Bank.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Bank.Repo, {:shared, self()})
    end

    on_exit(fn ->
      :ok = Application.stop(:bank)
      :ok = Application.stop(:commanded)

      {:ok, _apps} = Application.ensure_all_started(:bank)
    end)

    :ok
  end
end
