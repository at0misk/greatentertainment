class AddPermodToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :permod, :boolean
  end
end
