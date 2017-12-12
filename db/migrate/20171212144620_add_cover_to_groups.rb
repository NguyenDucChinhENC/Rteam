class AddCoverToGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :groups, :cover, :string
  end
end
