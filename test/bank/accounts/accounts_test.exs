defmodule Bank.AccountsTest do
  use Bank.DataCase
  import Bank.Factory

  alias Bank.Accounts
  alias Bank.Accounts.User

  # Users tests in Accounts context
  describe "get_user!/1" do
    test "returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user!(user.id) == user
    end

    test "raises error with invalid user id" do
      assert_raise(Ecto.NoResultsError, fn ->
        Accounts.get_user!("b0ecae3f-c21a-4542-bc2a-96a6c394d00e")
      end)
    end
  end

  describe "create_user/1" do
    test "creates a user with valid data" do
      user_params = params_for(:user)
      assert {:ok, %User{} = user} = Accounts.create_user(user_params)
      assert user.email == user_params.email
      assert user.encrypted_password == user_params.encrypted_password
      assert user.role == 0
    end

    test "returns error changeset with invalid data " do
      invalid_attrs = %{email: nil, encrypted_password: nil, role: nil}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_attrs)
    end
  end

  describe "create_admin/1" do
    test "creates a admin with valid data" do
      user_params = params_for(:user)
      assert {:ok, %User{} = user} = Accounts.create_admin(user_params)
      assert user.email == user_params.email
      assert user.encrypted_password == user_params.encrypted_password
      assert user.role == 10
    end

    test "returns error changeset with invalid data " do
      invalid_attrs = %{email: nil, encrypted_password: nil, role: nil}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_attrs)
    end
  end

  describe "change_user/1" do
    test "returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
