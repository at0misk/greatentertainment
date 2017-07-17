class Photo < ApplicationRecord
  attr_accessor :image
  do_not_validate_attachment_file_type :image
  belongs_to :user
  has_attached_file :image, styles: { medium: "300x300", thumb: "100x100" }
  validates_with AttachmentSizeValidator, attributes: :image, less_than: 1.megabytes
end
