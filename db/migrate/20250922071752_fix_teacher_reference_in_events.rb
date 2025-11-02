class FixTeacherReferenceInEvents < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :events, column: :teacher_id
    add_foreign_key :events, :users, column: :teacher_id
  end
end
