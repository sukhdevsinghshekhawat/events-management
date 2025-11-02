require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: "Sukhdev Singh",
      email: "sukhdev@example.com",
      password: "password",
      password_confirmation: "password",
      role: "student"
    )
  end

  test "valid user should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "123"
    assert_not @user.valid?
  end

  test "role should be student or admin" do
    @user.role = "teacher"
    assert_not @user.valid?
  end
end
