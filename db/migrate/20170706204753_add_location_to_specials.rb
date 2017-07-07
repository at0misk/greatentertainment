class AddLocationToSpecials < ActiveRecord::Migration[5.0]
  def change
  	add_column :specials, :location, :string
  end
end
