class CommissionsController < ApplicationController
	def index
		@user = User.find(session[:user_id])
	end
	def tracker
		@user = User.find(session[:user_id])
	end
	def create
		@commission = Commission.new(commission_params)
		if @commission.save
			# email commission here
		else
			flash[:errors] = "Something went wrong!"
		end
	end
	def commission_params
		params.require(:commission).permit(:email, :first, :last, :address, :city, :state, :country, :traveler_names, :traveler_phone, :traveler_email, :depart, :return, :itinerary, :ticket, :supplier, :airline, :hotel, :car_rental, :form, :last_4, :comments, :trip_total, :estimate)
	end
end
