class User < ApplicationRecord
	attr_accessor :avatar
	do_not_validate_attachment_file_type :avatar
	has_secure_password
	validates :email, :username, uniqueness: true
	has_many :topics
	has_many :messages
	has_many :blogs
	has_many :subscriptions
	has_many :cruises
	has_many :specials
	has_many :photos
	has_attached_file :avatar, styles: { medium: "300x300", thumb: "100x100" }
	validates_with AttachmentSizeValidator, attributes: :avatar, less_than: 2.megabytes

	def find_by_username(username)
		@found = User.find_by(username: username)
		if !@found
			@found = nil
		end
		@found
	end

	def to_param
		"#{self.username}"
	end

end
