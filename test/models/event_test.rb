require "test_helper"

class EventTest < ActiveSupport::TestCase
  def setup
    @teacher = User.create!(
      name: "Test Teacher",
      email: "unique_teacher_#{SecureRandom.hex(4)}@example.com",
      password: "password"
    )
    @event = Event.new(
      title: "Sample Event",
      venue: "Auditorium",
      date: Date.today,
      teacher: @teacher
    )
  end 
  
  test "should be valid" do
    assert @event.valid?
  end

  test "title should be present" do
    @event.title = ""
    assert_not @event.valid?
  end

  test "venue should be present" do
    @event.venue = ""
    assert_not @event.valid?
  end

  test "date should be present" do
    @event.date = nil
    assert_not @event.valid?
  end

  test "should belong to teacher" do
    assert_equal @teacher, @event.teacher
  end
end
