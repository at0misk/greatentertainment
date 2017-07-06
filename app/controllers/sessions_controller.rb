class SessionsController < ApplicationController
	def new
		# if session[:page_user_id]
		# 	@page_user = User.find(session[:page_user_id])
		# 	redirect_to "/#{@page_user.username}" and return
		# end
		session[:page_user_id] = nil
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
		@last_user = User.find(session[:user_id])
		session[:user_id] = nil
		session[:page_user_id] = nil
		redirect_to "/#{@last_user.username}"
	end
	def quote
		@page_user = User.find(session[:page_user_id])
	end
	def quote_process
		# Send email for quote here
		@user = User.find(session[:user_id])
		redirect_to "/#{@user.username}"
	end
	def interested
		# Send email for interest in special here
		@user = User.find(session[:user_id])
		redirect_to "/#{@user.username}"
	end
	def user_guide
	end
end
