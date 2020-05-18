class CreateVenues < ActiveRecord::Migration[6.0]
  def change
    create_table :venues do |t|
      t.string :name, null: false
      t.integer :age_restriction
      t.integer :capacity
      t.json :address, null: false
      
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :venues, :deleted_at
  end
end
