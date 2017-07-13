class AddProcessedToCommissions < ActiveRecord::Migration[5.0]
  def change
  	add_column :commissions, :processed, :boolean
  end
end
