class CommissionsController < ApplicationController
	def index
		@user = User.find(session[:user_id])
	end
	def tracker
		@user = User.find(session[:user_id])
	end
	def create
		@user = User.find(session[:user_id])
		@commission = Commission.new(commission_params)
		if @commission.save
			@user.address = @commission.address
			@user.city = @commission.city
			@user.state = @commission.state
			@user.country = @commission.country
			@user.zip = @commission.zip
			@user.save
			flash[:sent_mail] = true
			# email commission here
		else
			flash[:errors] = "Something went wrong!"
		end
		redirect_to "/#{@user.username}"
	end
	def commission_params
		params.require(:commission).permit(:user_id, :email, :first, :last, :address, :city, :state, :country, :traveler_names, :traveler_phone, :traveler_email, :depart, :return, :itinerary, :ticket, :supplier, :airline, :hotel, :car_rental, :form, :last_4, :comments, :trip_total, :estimate, :zip, :agent_id)
	end
end
