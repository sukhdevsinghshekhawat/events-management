class User < ApplicationRecord
  has_secure_password
  enum role: { student: "student", admin: "admin" }
  has_many :events, foreign_key: "teacher_id", dependent: :destroy
  has_many :registrations
  has_many :events, through: :registrations
end
