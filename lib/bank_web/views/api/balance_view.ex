defmodule BankWeb.Api.BalanceView do
  use BankWeb, :view

  alias Bank.Support.Utils

  def render("index.json", %{total: total, daily: daily, monthly: monthly, annual: annual}) do
    %{
      data: %{
        daily: render_many(daily, __MODULE__, "daily.json"),
        monthly: render_many(monthly, __MODULE__, "monthly.json"),
        annual: render_many(annual, __MODULE__, "annual.json"),
        total: render_many(total, __MODULE__, "total.json")
      }
    }
  end

  def render("total.json", %{balance: balance}) do
    %{
      debit: Utils.Float.to_real(balance.debit),
      credit: Utils.Float.to_real(balance.debit),
      balance: Utils.Float.to_real(balance.total)
    }
  end

  def render("annual.json", %{balance: balance}) do
    total = render_one(balance, __MODULE__, "total.json")
    Map.put(total, :year, balance.year)
  end

  def render("monthly.json", %{balance: balance}) do
    annual = render_one(balance, __MODULE__, "annual.json")
    Map.put(annual, :month, balance.month)
  end

  def render("daily.json", %{balance: balance}) do
    monthly = render_one(balance, __MODULE__, "monthly.json")
    Map.put(monthly, :day, balance.day)
  end
end
