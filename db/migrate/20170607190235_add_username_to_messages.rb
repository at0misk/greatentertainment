class AddUsernameToMessages < ActiveRecord::Migration[5.0]
  def change
  	add_column :messages, :username, :string
  end
end
