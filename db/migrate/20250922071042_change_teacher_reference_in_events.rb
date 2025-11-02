class ChangeTeacherReferenceInEvents < ActiveRecord::Migration[7.1]
  class ChangeTeacherReferenceInEvents < ActiveRecord::Migration[7.0]
  def change
    remove_reference :events, :teacher, foreign_key: true
    add_reference :events, :teacher, null: false, foreign_key: { to_table: :users }
  end
end
end
