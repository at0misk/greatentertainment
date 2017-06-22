class AddFeaturedToSpecials < ActiveRecord::Migration[5.0]
  def change
  	add_column :specials, :featured, :boolean
  end
end
