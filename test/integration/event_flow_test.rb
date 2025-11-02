require "test_helper"

class EventFlowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = User.create!(name: "Admin", email: "admin@example.com", password: "password", role: "admin")
    @student = User.create!(name: "Student", email: "student@example.com", password: "password", role: "student")
  end

  test "student can register for event" do
    log_in_as(@admin)
    post events_path, params: { event: { title: "Workshop", description: "Rails Workshop", venue: "Room 101", date: Date.today + 1, start_time: "10:00", end_time: "12:00", teacher_id: @admin.id } }
    event = Event.last
    delete logout_path # admin logout

    log_in_as(@student)
    post event_registrations_path(event), params: { registration: { rtu_roll_no: "24CMSXX642", semester: "MCA-3", mobile_no: "9876543210" } }
    follow_redirect!
    assert_select "div.notice", "Registered successfully!"
  end

  test "student cannot register twice" do
    log_in_as(@admin)
    post events_path, params: { event: { title: "Workshop", description: "Rails Workshop", venue: "Room 101", date: Date.today + 1, start_time: "10:00", end_time: "12:00", teacher_id: @admin.id } }
    event = Event.last
    delete logout_path

    log_in_as(@student)
    post event_registrations_path(event), params: { registration: { rtu_roll_no: "24CMSXX642", semester: "MCA-3", mobile_no: "9876543210" } }
    post event_registrations_path(event), params: { registration: { rtu_roll_no: "24CMSXX642", semester: "MCA-3", mobile_no: "9876543210" } }
    follow_redirect!
    assert_select "div.alert", "Already registered"
  end

  private
  def log_in_as(user)
    post login_path, params: { session: { email: user.email, password: "password" } }
  end
end
