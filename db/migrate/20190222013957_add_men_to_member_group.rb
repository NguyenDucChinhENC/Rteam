class AddMenToMemberGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :member_groups, :membergrouptable_id, :integer
  end
end
