defmodule BankWeb.Api.WalletView do
  use BankWeb, :view

  alias Bank.Support.Utils

  def render("show.json", %{wallet: wallet}) do
    %{data: render_one(wallet, __MODULE__, "wallet.json")}
  end

  def render("wallet.json", %{wallet: wallet}) do
    %{
      balance: Utils.Float.to_real(wallet.balance)
    }
  end
end
