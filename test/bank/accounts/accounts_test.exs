defmodule Bank.AccountsTest do
  use Bank.DataCase
  import Bank.Factory

  alias Bank.Accounts
  alias Bank.Accounts.User

  # Users tests in Accounts context
  describe "get_user!/1" do
    test "returns the user with given id" do
      created_user = insert(:user)

      user = Accounts.get_user!(created_user.id)

      assert user.email == created_user.email
      assert user.encrypted_password == created_user.encrypted_password
      assert user.role == created_user.role
    end

    test "raises error with invalid user id" do
      assert_raise(Ecto.NoResultsError, fn ->
        Accounts.get_user!("b0ecae3f-c21a-4542-bc2a-96a6c394d00e")
      end)
    end
  end

  describe "get_user_by_email/1" do
    test "returns the user with given email" do
      created_user = insert(:user)

      user = Accounts.get_user_by_email(created_user.email)

      assert user.email == created_user.email
    end

    test "returns nil with invalid user email" do
      refute Accounts.get_user_by_email("invalid@test.com")
    end
  end

  describe "create_user/1" do
    test "creates a user with valid data" do
      user_params = params_for(:user)

      assert {:ok, %User{} = user} = Accounts.create_user(user_params)
      assert user.email == user_params.email
      assert user.role == :user
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
      assert user.role == :admin
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

  describe "valid_password?/2" do
    setup do
      password = Pbkdf2.hash_pwd_salt("12345678")
      user = insert(:user, encrypted_password: password)
      %{user: user}
    end

    test "returns true with correct password", %{user: user} do
      assert Accounts.valid_password?(user, "12345678")
    end

    test "returns false with invalid password", %{user: user} do
      refute Accounts.valid_password?(user, "badpass")
    end

    test "returns false with nil user" do
      refute Accounts.valid_password?(nil, "badpass")
    end
  end
end
