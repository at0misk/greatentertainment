class SubscriptionsController < ApplicationController
	def subscribe
		@user = User.find(params[:id])
	end
	def new
		@page_user = User.find(session[:page_user_id])
	end
	def create
		subscription = Subscription.new(subscription_params)
		if Subscription.find_by(user_id: subscription.user_id, email: subscription.email)
			flash[:sub] = "You are already subscribed"
		else
			if subscription.save
				flash[:sub] = "Thanks for subscribing!"
			else
				flash[:sub] = "Something went wrong, please try again."
			end
		end
			redirect_back(fallback_location: "/subscriptions/#{subscription.user_id}")
	end
	def subscription_params
		params.require(:subscription).permit(:user_id, :email, :first, :last)
	end
	def index
		@user = User.find(session[:user_id])
		@subscriptions = Subscription.where(user_id: @user.id)
	end
	def destroy
		Subscription.find(params['id']).destroy
		redirect_back fallback_location: "/subscriptions"
	end
	def mail_subscribers
		@user = User.find(session[:user_id])
		@recipients = Subscription.where(user_id: @user.id)
		@recipients.each do |val|
			UserMailer.mail_subscribers(@user, val, params['subject'], params['content']).deliver_later
		end
		redirect_to "/#{@user.username}"
	end
end
