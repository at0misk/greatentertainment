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
				flash[:errors] = "Incorrect Password"
			end
		else
			flash[:errors] = "User Doesn't Exist"
		end
		redirect_to "/"
	end
	def admins_login
		@user = User.find_by(email: params['email'])
		if @user
			if @user.authenticate(params['password']) && @user.permod
				session[:user_id] = @user.id
				redirect_to "/admin_dash" and return 
			else
				flash[:errors] = "Incorrect Password / User Not An Admin"
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
		if session[:page_user_id]
			@page_user = User.find(session[:page_user_id])
		else
			redirect_to "/" and return
		end
	end
	def quote_process
		# Send email for quote here
		@user = User.find(session[:page_user_id])
		puts params['flexible']
		UserMailer.vacation(@user, params['first'], params['last'], params['email'], params['phone'], params['departure'], params['return'], params['flexible'], params['explore-options'], params['other-explore'], params['vibe-options'], params['other-vibe'], params['activity-options'], params['other-activity'], params['view-options'], params['other-view'], params['include-options'], params['other-include'], params['budget'], params['star-options'], params['rentalcar-options'], params['other-rentalcar'], params['party-size'], params['traveler-type-options'], params['occasion-options'], params['other-occasion'], params['comments'], params['contact_preference']).deliver_now
		flash[:sent_mail] = true
		if params['subscribe']
			subscription = Subscription.new(user_id: session[:user_id], email: params['email'], first: params['first'], last: params['last'])
			subscription.save
		end
		redirect_to "/#{@user.username}"
	end
	def interested
		# Send email for interest in special here
		@user = User.find(session[:user_id])
		@special = Special.find(params['special_id'])
		UserMailer.user_special(@user, @special, params['first'], params['last'], params['email'], params['phone_number'], params['message']).deliver_now
		flash[:sent_mail] = true
		redirect_to "/#{@user.username}"
	end
	def user_guide
	end
	def privacy_policy
	end
	def register
		# redirect_to "/"
	end
	def resources
	end
end
