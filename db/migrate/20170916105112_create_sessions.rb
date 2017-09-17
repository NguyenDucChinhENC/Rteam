class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.integer :id_user
      t.string :token_session
      t.timestamps
    end
  end
end
