class AddInfoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :number_phone, :integer
    add_column :users, :birthday, :datetime
    add_column :users, :address, :string
    add_column :users, :country, :string
    add_column :users, :id_number, :integer
    add_column :users, :link_facebook, :string
    add_column :users, :workplace, :string
  end
end
