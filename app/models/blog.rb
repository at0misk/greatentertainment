class Blog < ApplicationRecord
  attr_accessor :image
  do_not_validate_attachment_file_type :image
  belongs_to :user
  has_attached_file :image, styles: { medium: "300x300", thumb: "100x100" }
end