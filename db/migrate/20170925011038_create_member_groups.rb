class CreateMemberGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :member_groups do |t|
      t.integer :id_user
      t.integer :id_group
      t.boolean :admin, default: false
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
