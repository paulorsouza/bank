defmodule Bank.CredentialsTest do
  use Bank.DataCase
  import Bank.Factory

  alias Bank.Credentials
  alias Bank.Credentials.Projections.User

  describe "get_user_by_user_or_email/1" do
    test "returns the user with given email" do
      created_user = insert(:user_projection)

      user = Credentials.get_user_by_user_or_email(created_user.email)

      assert user.email == created_user.email
    end

    test "returns the user with given username" do
      created_user = insert(:user_projection)

      user = Credentials.get_user_by_user_or_email(created_user.username)

      assert user.email == created_user.email
    end

    test "returns nil with invalid user email" do
      refute Credentials.get_user_by_user_or_email("invalid@test.com")
    end
  end

  describe "create_user/1" do
    test "creates a user with valid data" do
      assert {:ok, %User{} = user} = Credentials.create_user(build(:user))
    end
  end
end
