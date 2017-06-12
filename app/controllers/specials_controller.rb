class SpecialsController < ApplicationController
	def new
		@user = User.find(params['id'])
	end
	def create
		@special = Special.new(special_params)
		if @special.save
		else
		end
		redirect_to "/#{@special.user.username}"
	end
	def special_params
		params.require(:special).permit(:title, :depart, :return, :vacancy, :description, :user_id)
	end
	def view
		@user = User.find(session[:user_id])
		@special = Special.find(params['id'])
	end
end
