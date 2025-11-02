# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(name: "Prof. Sharma", email: "teacher@example.com", password: "password", role: "teacher")
User.create!(name: "Amit Kumar", email: "student@example.com", password: "password", role: "student")

student = User.find_or_create_by!(email: "student@maism.com") do |u|
  u.name = "Student One"
  u.password = "password"
  u.password_confirmation = "password"
  u.role = "student"
end

event = teacher.events.find_or_create_by!(title: "Hackathon 2025", date: "2025-09-25", venue: "MAISM Hall") do |e|
  e.description = "College Hackathon — build cool projects!"
  e.start_time = "10:00"
  e.end_time = "17:00"
end
