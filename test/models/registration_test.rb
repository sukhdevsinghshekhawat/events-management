require "test_helper"

class RegistrationTest < ActiveSupport::TestCase
  def setup
    @user = User.create(name: "Test User", email: "test@example.com", password: "password", role: "student")
    @event = Event.create(title: "Sample Event", venue: "Auditorium", date: Date.today, start_time: "10:00", end_time: "12:00", teacher: @user, description: "Test Event")
    @registration = Registration.new(user: @user, event: @event, rtu_roll_no: "24CMSXX642", semester: "MCA-1", mobile_no: "9876543210")
  end

  test "should be valid with all attributes" do
    assert @registration.valid?
  end

  test "rtu_roll_no should be present" do
    @registration.rtu_roll_no = ""
    assert_not @registration.valid?
  end

  test "semester should be present" do
    @registration.semester = ""
    assert_not @registration.valid?
  end

  test "mobile_no should be 10 digits" do
    @registration.mobile_no = "12345"
    assert_not @registration.valid?
  end

  test "user should not register for same event twice" do
    @registration.save
    duplicate = @registration.dup
    assert_not duplicate.valid?
  end
end
