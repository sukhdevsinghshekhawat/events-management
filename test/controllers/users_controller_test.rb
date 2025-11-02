require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new (signup page)" do
    get signup_path
    assert_response :success
    assert_select "h2", "Create your account"
  end

  test "should create user with valid data" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { 
        name: "Sukhdev Singh",
        email: "sukhdev@example.com",
        password: "password",
        password_confirmation: "password",
        role: "student"
      } }
    end
    follow_redirect!
    assert_select "div.notice", "Account created successfully!"
  end

  test "should not create user with invalid data" do
    assert_no_difference 'User.count' do
      post users_path, params: { user: { 
        name: "",
        email: "invalid",
        password: "123",
        password_confirmation: "321",
        role: "student"
      } }
    end
    assert_select "div.alert" # shared/form_errors partial render check
  end

  test "should show user profile" do
    user = User.create!(name: "Sukhdev", email: "sukh@example.com", password: "password", role: "student")
    get user_path(user)
    assert_response :success
    assert_select "h2", user.name
  end

  test "should get edit page" do
    user = User.create!(name: "Sukhdev", email: "sukh@example.com", password: "password", role: "student")
    log_in_as(user)
    get edit_user_path(user)
    assert_response :success
  end

  test "should update user with valid data" do
    user = User.create!(name: "Sukhdev", email: "sukh@example.com", password: "password", role: "student")
    log_in_as(user)
    patch user_path(user), params: { user: { name: "Updated Name" } }
    follow_redirect!
    assert_select "div.notice", "Profile updated successfully!"
    user.reload
    assert_equal "Updated Name", user.name
  end

  test "should not update user with invalid data" do
    user = User.create!(name: "Sukhdev", email: "sukh@example.com", password: "password", role: "student")
    log_in_as(user)
    patch user_path(user), params: { user: { email: "invalid" } }
    assert_select "div.alert"
    user.reload
    assert_equal "sukh@example.com", user.email
  end

  private
  # helper to log in a user during integration test
  def log_in_as(user)
    post login_path, params: { session: { email: user.email, password: "password" } }
  end
end
