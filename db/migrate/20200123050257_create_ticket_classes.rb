class CreateTicketClasses < ActiveRecord::Migration[6.0]
  def change
    create_table :ticket_classes do |t|
      t.string :name
      t.string :description
      t.integer :minimum_quantity
      t.integer :maximum_quantity
      t.monetize :cost
      t.integer :sorting
      t.integer :capacity
      t.datetime :sales_start
      t.datetime :sales_end
      t.string :order_confirmation_message

      t.references :event, foreign_key: true

      t.datetime :deleted_at
      t.timestamps
    end
    add_index :ticket_classes, :deleted_at
  end
end
