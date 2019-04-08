defmodule Bank.Accounts.Email do
  @moduledoc false

  use Bamboo.Phoenix, view: BankWeb.EmailView
  alias Bank.Support.Utils

  def withdraw(user, amount, balance) do
    html = html(user.username, amount, balance)

    new_email()
    |> to(user.email)
    |> from("mailertabajara@gmail.com")
    |> subject("Successful withdrawal!")
    |> html_body(html)
  end

  defp html(username, amount, balance) do
    """
    <p>Hello #{username},</p>

    <p>#{Utils.Float.to_real(amount)} withdraw successfully</p>
    <p>Your new balance is #{Utils.Float.to_real(balance)}

    """
  end
end
