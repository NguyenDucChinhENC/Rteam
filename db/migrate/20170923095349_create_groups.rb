class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.boolean :public_status
      t.boolean :enable_search
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
