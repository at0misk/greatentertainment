class CommissionsController < ApplicationController
	def index
		@user = User.find(session[:user_id])
	end
	def tracker
		@user = User.find(session[:user_id])
	end
end
