class AddColumngUserToMemberGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :member_groups, :membergrouptable_type, :string
  end
end
