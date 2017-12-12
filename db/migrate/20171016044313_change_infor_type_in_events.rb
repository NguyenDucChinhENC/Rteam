class ChangeInforTypeInEvents < ActiveRecord::Migration[5.1]
  def change
  	change_column :events, :infor, :text
  end
end
