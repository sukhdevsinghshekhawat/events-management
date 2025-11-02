require "test_helper"

class UserFlowTest < ActionDispatch::IntegrationTest
  test "user signup with valid data" do
    get signup_path
    assert_response :success

    post users_path, params: { user: { 
      name: "Sukhdev Singh",
      email: "sukhdev@example.com",
      password: "password",
      password_confirmation: "password",
      role: "student"
    } }

    follow_redirect!
    assert_select "div.notice", "Account created successfully!" # ya jo flash message tum use kar rahe ho
  end

  test "user signup with invalid data" do
    get signup_path
    assert_response :success

    post users_path, params: { user: { 
      name: "",
      email: "invalidemail",
      password: "123",
      password_confirmation: "321",
      role: "student"
    } }

    assert_select "div.alert" # ye hamara shared/_form_errors partial render karega
    assert_select "li", /can't be blank/
    assert_select "li", /is invalid/
    assert_select "li", /doesn't match password/
  end

  test "user login with valid credentials" do
    user = User.create!(name: "Sukhdev", email: "sukh@example.com", password: "password", role: "student")
    
    get login_path
    assert_response :success

    post login_path, params: { session: { email: user.email, password: "password" } }
    follow_redirect!
    assert_select "div.notice", "Logged in successfully!" # ya tumhare flash message
  end

  test "user login with invalid credentials" do
    get login_path
    assert_response :success

    post login_path, params: { session: { email: "wrong@example.com", password: "1234" } }
    assert_select "div.alert", "Invalid email/password combination" # ya tumhare login error message
  end
end
