class CreateTicketClasses < ActiveRecord::Migration[6.0]
  def change
    create_table :ticket_classes do |t|
      t.string :name, null: false
      t.string :description
      t.monetize :price
      t.integer :sorting
      t.integer :capacity
      t.datetime :sales_start
      t.datetime :sales_end

      t.references :event, null: false, foreign_key: true

      t.datetime :deleted_at
      t.timestamps
    end
    add_index :ticket_classes, :deleted_at
  end
end
