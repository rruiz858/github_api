class CreateCachedTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :cached_tokens do |t|
      t.string :token
      t.integer :service
    end
  end
end
