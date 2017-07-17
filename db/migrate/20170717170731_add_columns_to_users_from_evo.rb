class AddColumnsToUsersFromEvo < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :c2go, :string
  	add_column :users, :apt, :string
  	add_column :users, :upline_id, :integer
  end
end
