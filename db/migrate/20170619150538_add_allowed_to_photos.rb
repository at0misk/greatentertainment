class AddAllowedToPhotos < ActiveRecord::Migration[5.0]
  def change
  	add_column :photos, :allowed, :boolean, null: false, default: false
  end
end
