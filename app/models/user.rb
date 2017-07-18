require 'roo'

class User < ApplicationRecord
	attr_accessor :avatar
	attr_accessor :skip_email_validation
	do_not_validate_attachment_file_type :avatar
	has_secure_password
	validates :email, :username, uniqueness: true, unless: :skip_email_validation
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

	def self.import(file)
	  spreadsheet = Roo::Spreadsheet.open(file.path)
	  header = spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
			row = Hash[[header, spreadsheet.row(i)].transpose]
			user = find_by(agent_id: row["ID"])
			if !user
				user = User.new
				random_password = Array.new(10).map { (65 + rand(58)).chr }.join
				user.password = random_password
			end
			user.agent_id = row['ID']
			user.upline_id = row['SponsorID']
			user.first = row['FirstName']
			user.last = row['LastName']
			user.c2go = row['C2GOID']
			user.username = row['WebRepName']
			user.address = row['Address']
			user.apt = row['Apt']
			user.city = row['City']
			user.state = row['State']
			user.zip = row['Zip']
			user.country = row['Country']
			user.phone_number = row['Cellular']
			user.email = row['Email']
			user.skip_email_validation = true
			if user.save(validate => false)
			else
				puts "failed to save"
			end
		end
	end

end
