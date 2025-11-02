class Announcement < ApplicationRecord
  belongs_to :event
  belongs_to :user  # teacher who posted
  validates :message, presence: true
end
