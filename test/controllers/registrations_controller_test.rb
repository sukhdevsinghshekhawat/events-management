require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @student = User.create(name: "Student", email: "student@example.com", password: "password", role: "student")
    @teacher = User.create(name: "Teacher", email: "teacher@example.com", password: "password", role: "admin")
    @event = Event.create(title: "Sample Event", venue: "Auditorium", date: Date.today, start_time: "10:00", end_time: "12:00", teacher: @teacher, description: "Test Event")
  end

  test "should get new registration page" do
    sign_in_as(@student)
    get new_event_registration_path(@event)
    assert_response :success
    assert_select "h3", "Event Registration"
  end

  test "should create registration with valid data" do
    sign_in_as(@student)
    assert_difference "Registration.count", 1 do
      post event_registrations_path(@event), params: { registration: { rtu_roll_no: "24CMSXX642", semester: "MCA-1", mobile_no: "9876543210" } }
    end
    assert_redirected_to event_path(@event)
    follow_redirect!
    assert_match "Registered successfully", response.body
  end

  test "should not create registration with invalid data" do
    sign_in_as(@student)
    assert_no_difference "Registration.count" do
      post event_registrations_path(@event), params: { registration: { rtu_roll_no: "", semester: "", mobile_no: "123" } }
    end
    assert_response :success
    assert_select "div.alert-danger"
  end

  test "should destroy registration" do
    sign_in_as(@student)
    registration = @event.registrations.create(user: @student, rtu_roll_no: "24CMSXX642", semester: "MCA-1", mobile_no: "9876543210")
    assert_difference "Registration.count", -1 do
      delete event_registration_path(@event, registration)
    end
    assert_redirected_to event_path(@event)
  end
end
