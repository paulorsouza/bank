defmodule Bank.Crendetials.Aggregates.UserTest do
  use Bank.AggregateCase, aggregate: Bank.Credentials.Aggregates.User

  alias Bank.Credentials.Events.UserCreated

  describe "create user" do
    @tag :aggregates
    test "should succeed when valid" do
      user_uuid = UUID.uuid4()
      user_create = build(:create_user, user_uuid: user_uuid)

      assert_events(user_create, [
        %UserCreated{
          user_uuid: user_uuid,
          email: user_create.email,
          username: user_create.username,
          encrypted_password: nil
        }
      ])
    end
  end
end
