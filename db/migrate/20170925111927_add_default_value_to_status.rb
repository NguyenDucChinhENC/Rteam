class AddDefaultValueToStatus < ActiveRecord::Migration[5.1]
  def change
  	change_column :member_groups, :admin, :boolean, default: false
  	change_column :member_groups, :status, :boolean, default: true
  end
end
