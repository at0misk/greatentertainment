class CruisesController < ApplicationController
	def new
		@user = User.find(params['id'])
	end
	def create
		@cruise = Cruise.new(cruise_params)
		if @cruise.save
		else
		end
		redirect_to "/#{@cruise.user.username}"
	end
	def cruise_params
		params.require(:cruise).permit(:title, :departure, :return, :vacancy, :description, :user_id)
	end
	def view
		@cruise = Cruise.find(params['id'])
	end
end
