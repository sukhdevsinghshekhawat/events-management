class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :venue
      t.date :date
      t.time :start_time
      t.time :end_time
      t.references :teacher, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
