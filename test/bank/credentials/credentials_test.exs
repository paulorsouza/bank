defmodule Bank.CredentialsTest do
  use Bank.DataCase
  import Bank.Factory

  alias Bank.Credentials
  alias Bank.Credentials.Projections.User

  describe "get_user_by_user_or_email/1" do
    @describetag :readstore
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

  describe "get_user_by_email/1" do
    @describetag :readstore
    test "returns the user with given email" do
      created_user = insert(:user_projection)

      user = Credentials.get_user_by_email(created_user.email)

      assert user.email == created_user.email
    end

    test "returns nil with invalid user email" do
      refute Credentials.get_user_by_user_or_email("invalid@test.com")
    end
  end

  describe "get_user_by_username/1" do
    @describetag :readstore
    test "returns the user with given username" do
      created_user = insert(:user_projection)

      user = Credentials.get_user_by_username(created_user.username)

      assert user.email == created_user.email
    end

    test "returns nil with invalid user email" do
      refute Credentials.get_user_by_user_or_email("invalid@test.com")
    end
  end

  describe "create_user/1" do
    @describetag :eventstore
    test "creates a user with valid data" do
      create_user = build(:user)

      assert {:ok, %User{} = user} = Credentials.create_user(create_user)

      assert user.username == create_user.username
      assert user.email == create_user.email
    end

    test "should fail with invalid data and return error" do
      assert {:error, :validation_failure, errors} =
               Credentials.create_user(build(:user, username: ""))

      assert errors == %{username: ["must have a length between 2 and 20"]}
    end

    test "should fail when username already taken and return error" do
      assert {:ok, %User{}} = Credentials.create_user(build(:user, username: "sameuser"))

      assert {:error, :validation_failure, errors} =
               Credentials.create_user(build(:user, username: "sameuser"))

      assert errors == %{username: ["has already been taken"]}
    end

    test "should fail when registering identical username at same time and return error" do
      1..2
      |> Enum.map(fn _ ->
        Task.async(fn -> Credentials.create_user(build(:user, username: "sameuser")) end)
      end)
      |> Enum.map(&Task.await/1)
    end

    test "should fail when username format is invalid and return error" do
      assert {:error, :validation_failure, errors} =
               Credentials.create_user(build(:user, username: "test@test-"))

      assert errors == %{username: ["is invalid"]}
    end

    test "should fail when email address already taken and return error" do
      assert {:ok, %User{}} = Credentials.create_user(build(:user, email: "sameemail@test.com"))

      assert {:error, :validation_failure, errors} =
               Credentials.create_user(build(:user, email: "sameemail@test.com"))

      assert errors == %{email: ["has already been taken"]}
    end

    test "should fail when registering identical email addresses at same time and return error" do
      1..2
      |> Enum.map(fn _ ->
        Task.async(fn -> Credentials.create_user(build(:user, email: "sameemail@test.com")) end)
      end)
      |> Enum.map(&Task.await/1)
    end

    test "should fail when email address format is invalid and return error" do
      assert {:error, :validation_failure, errors} =
               Credentials.create_user(build(:user, email: "invalidemail"))

      assert errors == %{email: ["is invalid"]}
    end

    test "should hash password" do
      assert {:ok, %User{} = user} = Credentials.create_user(build(:user))

      assert Bank.Credentials.Auth.valid_password?(user, "12345678")
    end
  end
end
