class AddKeyToCommissions < ActiveRecord::Migration[5.0]
  def change
  	add_column :commissions, :key, :string
  end
end
