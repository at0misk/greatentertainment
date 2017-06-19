class AddNameToPhotos < ActiveRecord::Migration[5.0]
  def change
  	add_column :photos, :name, :string
  	add_column :photos, :location, :string
  	add_column :photos, :traveled_on, :date
  end
end
