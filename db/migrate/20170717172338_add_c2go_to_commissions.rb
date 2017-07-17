class AddC2goToCommissions < ActiveRecord::Migration[5.0]
  def change
  	add_column :commissions, :c2go, :string
  end
end
