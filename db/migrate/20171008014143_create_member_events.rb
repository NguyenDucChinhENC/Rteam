class CreateMemberEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :member_events do |t|
      t.references :event, foreign_key: true
      t.integer :user_id
      t.boolean :status, default: true
      
      t.timestamps
    end
  end
end
