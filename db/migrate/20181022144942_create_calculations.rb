class CreateCalculations < ActiveRecord::Migration[5.2]
  def change
    create_table :calculations do |t|
      t.integer :min_range
      t.integer :max_range
      t.integer :projects_count
      t.boolean :is_finished_calculating
      t.timestamps
    end
  end
end
