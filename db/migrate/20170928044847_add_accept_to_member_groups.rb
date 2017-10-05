class AddAcceptToMemberGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :member_groups, :accept, :boolean, default: true
  end
end
