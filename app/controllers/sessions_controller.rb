class SessionsController < ApplicationController
	def new
	end
	def create
		@user = User.find_by(email: params['email'])
		if @user
			if @user.authenticate(params['password'])
				session[:user_id] = @user.id
			else
				flash[:errors] = "Incorrect password"
			end
		else
			flash[:errors] = "User doesn't exist"
		end
		redirect_to "/#{@user.username}"
	end
end
