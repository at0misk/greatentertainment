class AddZipToCommissions < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :zip, :string
  	add_column :commissions, :zip, :string
  end
end
