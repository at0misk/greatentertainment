class AddAttachmentImageToSpecials < ActiveRecord::Migration
  def self.up
    change_table :specials do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :specials, :image
  end
end
