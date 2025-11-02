class Event < ApplicationRecord
  belongs_to :teacher, class_name: "User"

  has_many :registrations, dependent: :destroy
  has_many :students, through: :registrations, source: :user
  has_many :announcements, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :title, :date, :venue, presence: true
end
