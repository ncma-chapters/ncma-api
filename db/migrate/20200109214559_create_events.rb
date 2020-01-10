class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.references :venue, foreign_key: true
      t.datetime :published_at
      t.datetime :starting_at
      t.datetime :ending_at
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :events, :deleted_at
    add_index :events, :published_at
  end
end
