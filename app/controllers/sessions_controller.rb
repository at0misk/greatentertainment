class SessionsController < ApplicationController
	def new
		# if session[:page_user_id]
		# 	@page_user = User.find(session[:page_user_id])
		# 	redirect_to "/#{@page_user.username}" and return
		# end
	end
	def create
		@user = User.find_by(email: params['email'])
		if @user
			if @user.authenticate(params['password'])
				session[:user_id] = @user.id
				redirect_to "/#{@user.username}" and return 
			else
				flash[:errors] = "Incorrect password"
			end
		else
			flash[:errors] = "User doesn't exist"
		end
		redirect_to "/"
	end
	def logout
		session[:user_id] = nil
		redirect_to '/'
	end
	def quote
		@page_user = User.find(session[:page_user_id])
	end
end
