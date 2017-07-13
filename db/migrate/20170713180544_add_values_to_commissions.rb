class AddValuesToCommissions < ActiveRecord::Migration[5.0]
  def change
  	add_column :commissions, :trip_total, :decimal, :precision => 8, :scale => 4
  	add_column :commissions, :estimate, :decimal, :precision => 8, :scale => 4
  	add_column :commissions, :agent_id, :string
  	add_column :users, :agent_id, :string
  	add_column :users, :address, :string
  	add_column :users, :city, :string
  	add_column :users, :state, :string
  	add_column :users, :country, :string
  end
end
