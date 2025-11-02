require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = User.create!(name: "Admin", email: "admin@example.com", password: "password", role: "admin")
    @teacher = User.create!(name: "Teacher", email: "teacher@example.com", password: "password", role: "teacher")
    @event = Event.create!(title: "Sample Event", venue: "Hall B", date: Date.today, start_time: "10:00", end_time: "12:00", teacher: @teacher)
  end

  test "should get index" do
    get events_path
    assert_response :success
  end

  test "should get show" do
    get event_path(@event)
    assert_response :success
  end

  test "admin should create event" do
    sign_in_as(@admin)
    post events_path, params: { event: { title: "New Event", venue: "Hall C", date: Date.today, start_time: "10:00", end_time: "12:00", teacher_id: @teacher.id } }
    assert_redirected_to event_path(Event.last)
  end

  test "non-admin should not create event" do
    sign_in_as(@teacher)
    post events_path, params: { event: { title: "New Event", venue: "Hall C", date: Date.today, start_time: "10:00", end_time: "12:00", teacher_id: @teacher.id } }
    assert_redirected_to root_path
  end
end
