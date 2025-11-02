class AddDetailsToRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :registrations, :rtu_roll_no, :string
    add_column :registrations, :semester, :string
    add_column :registrations, :mobile_no, :string
  end
end
