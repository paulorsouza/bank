defmodule Bank.Credentials.AuthTest do
  use Bank.DataCase
  import Bank.Factory

  alias Bank.Credentials

  describe "valid_password?/2" do
    setup do
      password = Pbkdf2.hash_pwd_salt("12345678")
      user = insert(:user_projection, encrypted_password: password)
      %{user: user}
    end

    test "returns true with correct password", %{user: user} do
      assert Credentials.Auth.valid_password?(user, "12345678")
    end

    test "returns false with invalid password", %{user: user} do
      refute Credentials.Auth.valid_password?(user, "badpass")
    end

    test "returns false with nil user" do
      refute Credentials.Auth.valid_password?(nil, "badpass")
    end
  end
end
