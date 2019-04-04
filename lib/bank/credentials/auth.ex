defmodule Bank.Credentials.Auth do
  @moduledoc false

  # runs the hash function, but always returns false
  def valid_password?(nil, _given_password) do
    Pbkdf2.no_user_verify()
  end

  def valid_password?(user, given_password) do
    Pbkdf2.verify_pass(given_password, user.encrypted_password)
  end

  def encrypt_password(password), do: Pbkdf2.hash_pwd_salt(password)
end
