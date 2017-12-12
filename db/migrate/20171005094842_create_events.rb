class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name
      t.integer :eventtable_id
      t.string :eventtable_type
      t.integer :quantity
      t.datetime :time
      t.string :location
      t.datetime :registration_deadline
      t.string :infor
      t.boolean :status, default: true

      t.timestamps
    end

    add_index :events, :eventtable_id
  end
end
