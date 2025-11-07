class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  before_save :downcase_email

  enum role: { student: "student", admin: "admin", super_admin: "super_admin"  }
  has_many :events, foreign_key: "teacher_id", dependent: :destroy
  has_many :registrations
  has_many :events, through: :registrations
  after_initialize :set_default_role, if: :new_record?
  before_create :generate_verification_token

  def super_admin?
    role == "super_admin"
  end

  private
    def set_default_role
      self.role ||= "student"
    end

    def generate_verification_token
      self.verification_token = SecureRandom.hex(10)
      self.email_verified = false
    end
    def downcase_email
      self.email = email.downcase
    end
end
