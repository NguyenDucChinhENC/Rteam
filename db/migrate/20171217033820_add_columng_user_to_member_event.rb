class AddColumngUserToMemberEvent < ActiveRecord::Migration[5.1]
  def change
  	add_column :member_events, :membereventtable_type, :string
  end
end
