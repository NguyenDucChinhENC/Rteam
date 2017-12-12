class CreateAdminEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_events do |t|
      t.references :event, foreign_key: true
      t.integer :user_id

      t.timestamps
    end
  end
end
