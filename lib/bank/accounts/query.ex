defmodule Bank.Accounts.Query do
  @moduledoc false

  import Ecto.Query

  alias Bank.Accounts.Projections.Operation

  def operations(wallet_uuid) do
    from o in Operation,
      where: o.wallet_uuid == ^wallet_uuid
  end

  def balance(wallet_uuid) do
    from o in operations(wallet_uuid),
      left_join: d in ^debits(),
      on: d.id == o.id,
      left_join: c in ^credits(),
      on: c.id == o.id,
      select: %{
        debit: d.amount |> sum() |> coalesce(0),
        credit: c.amount |> sum() |> coalesce(0),
        total: (c.amount |> sum() |> coalesce(0)) - (d.amount |> sum() |> coalesce(0))
      }
  end

  def debits do
    from o in Operation, where: o.type in [1, 2]
  end

  def credits do
    from o in Operation, where: o.type in [0, 3]
  end

  def balance_per_day(wallet_uuid) do
    {:ok, uuid} = Ecto.UUID.dump(wallet_uuid)

    {:ok, %{rows: rows}} =
      query(
        """
        select to_char(date_part('day', o.operation_date), '00') as day,
               to_char(date_part('month', o.operation_date), '00') as month,
               to_char(date_part('year', o.operation_date), '0000') as year,
               coalesce(sum(debits.amount), 0) as d,
               coalesce(sum(credits.amount), 0) as c,
               coalesce(sum(credits.amount), 0) - coalesce(sum(debits.amount), 0) as t
        from operations o
        left join operations debits on debits.id = o.id and debits.type in (1,2)
        left join operations credits on credits.id = o.id and credits.type in (0,3)
        where o.wallet_uuid = $1
        group by day, month, year
        """,
        [uuid]
      )

    Enum.map(rows, fn [d, m, y, deb, cred, tot] ->
      %{day: d, month: m, year: y, debit: deb, credit: cred, total: tot}
    end)
  end

  def balance_per_month(wallet_uuid) do
    {:ok, uuid} = Ecto.UUID.dump(wallet_uuid)

    {:ok, %{rows: rows}} =
      query(
        """
        select to_char(date_part('month', o.operation_date), '00') as month,
               to_char(date_part('year', o.operation_date), '0000') as year,
               coalesce(sum(debits.amount), 0) as d,
               coalesce(sum(credits.amount), 0) as c,
               coalesce(sum(credits.amount), 0) - coalesce(sum(debits.amount), 0) as t
        from operations o
        left join operations debits on debits.id = o.id and debits.type in (1,2)
        left join operations credits on credits.id = o.id and credits.type in (0,3)
        where o.wallet_uuid = $1
        group by month, year
        """,
        [uuid]
      )

    Enum.map(rows, fn [m, y, deb, cred, tot] ->
      %{month: m, year: y, debit: deb, credit: cred, total: tot}
    end)
  end

  def balance_per_year(wallet_uuid) do
    {:ok, uuid} = Ecto.UUID.dump(wallet_uuid)

    {:ok, %{rows: rows}} =
      query(
        """
        select to_char(date_part('year', o.operation_date), '0000') as year,
               coalesce(sum(debits.amount), 0) as d,
               coalesce(sum(credits.amount), 0) as c,
               coalesce(sum(credits.amount), 0) - coalesce(sum(debits.amount), 0) as t
        from operations o
        left join operations debits on debits.id = o.id and debits.type in (1,2)
        left join operations credits on credits.id = o.id and credits.type in (0,3)
        where o.wallet_uuid = $1
        group by year
        """,
        [uuid]
      )

    Enum.map(rows, fn [y, deb, cred, tot] ->
      %{year: y, debit: deb, credit: cred, total: tot}
    end)
  end

  defp query(sql, values) do
    Ecto.Adapters.SQL.query(Bank.Repo, sql, values)
  end
end
