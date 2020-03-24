class CreateEventRegistrations < ActiveRecord::Migration[6.0]
  def change
    create_table :event_registrations do |t|
      t.json :data, null: false

      t.references :ticket_class, null: false, foreign_key: true

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
