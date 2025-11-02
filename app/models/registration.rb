class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :event

  # Ensure a user registers only once per event
  validates :user_id, uniqueness: { scope: :event_id, message: "already registered for this event" }

  # RTU Roll No minimum 10 characters
  validates :rtu_roll_no, presence: true, length: { minimum: 10, message: "must be at least 10 characters" }

  # Semester presence
  validates :semester, presence: true

  # Mobile number exactly 10 digits
  validates :mobile_no, presence: true, format: { with: /\A\d{10}\z/, message: "must be exactly 10 digits" }
end
