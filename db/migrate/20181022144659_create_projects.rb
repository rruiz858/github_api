class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :owner
      t.string :url
      t.integer :stars
      t.integer :github_id
      t.index :github_id, unique: true
      t.timestamps
    end
  end
end
