class Commission < ApplicationRecord
  belongs_to :user
  	def self.import(file)
	  spreadsheet = Roo::Spreadsheet.open(file.path)
	  header = spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
			row = Hash[[header, spreadsheet.row(i)].transpose]
			transaction = find_by(key: row["key"]) || new
			user = User.find_by(evo_id: row['evo_id'])
			if user
				commission.key = row['key']
				commission.agent_id = row['evo_id']
				commission.upline_id = user.upline_id
				commission.country = user.country
				commission.agent_total = (row['commission_total']*0.8).round(2)
				commission.upline_total = (row['commission_total']*0.1).round(2)
				commission.evo_total = (row['commission_total']*0.1).round(2)
				commission.commission_total = row['commission_total']
				commission.invoice = row['invoice']
				commission.traveler = row['traveler']
				commission.itinerary = row['itinerary']
				commission.issue_date = row['issue_date']
				commission.save!
			end
		end
	end
end
