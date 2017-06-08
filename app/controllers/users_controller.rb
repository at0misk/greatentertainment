class UsersController < ApplicationController
	def create
		@user = User.new(user_params)
		@dupe_user = User.find_by_username(@user.username)
		@dupe_email = User.find_by(email: @user.email)
		if @dupe_user
			flash[:errors] = "Username already taken"
		elsif @dupe_email
			flash[:errors] = "Email already in use"
		end
		if @user.save
			flash[:created] = true
			session[:user_id] = @user.id
			redirect_to "/#{@user.username}" and return 
		else
			flash[:created] = false
		end
		redirect_to '/'
	end
	def user_params
  		params.require(:user).permit(:first, :last, :email, :username, :password, :password_confirmation, :phone_number, :avatar, :about) 
	end
	def show
		@page_user = User.find_by_username(params['username'])
		if !@page_user
			redirect_to '/'
		else
			@current_user = User.find(session[:user_id]) if session[:user_id]
			@request_count = Topic.where(user_id: session[:user_id]).length if session[:user_id]
				if @request_count && @request_count > 0
					@page_user_topics = Topic.where(user_id: session[:user_id])
				end
		end
		@latest = Blog.where(user_id: @page_user.id).last
	end
	def edit
		@user = User.find_by_username(params['username'])
	end
	def update
		@user = User.find_by_username(params['username'])
	    if @user.update(user_params)
	    	flash[:errors] = nil
	    else
	    	flash[:errors] = @user.errors.full_messages
	    end
	    redirect_to "/#{@user.username}"
	end
	def destroy
		User.find_by_username(params['username']).destroy
		session[:user_id] = nil
		redirect_to '/'
	end
	def requests
		@user = User.find(session[:user_id])
		@topics = Topic.where(user_id: @user.id)
		# if !@user.permod
		# 	redirect_to '/'
		# end
	end
	def request_chat
		@agent = User.find(params['id'])
	end
end
