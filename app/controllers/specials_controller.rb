class SpecialsController < ApplicationController
	def new
		@user = User.find(session[:user_id])
	end
	def create
		@featured = Special.where(user_id: session[:user_id], featured: true).first
		if @featured
			@featured.update_attribute(:featured, false)
		end
		@special = Special.new(special_params)
		if @special.save
		else
		end
		redirect_to "/#{@special.user.username}"
	end
	def special_params
		params.require(:special).permit(:title, :depart, :return, :vacancy, :description, :user_id, :image, :price, :featured)
	end
	def view
		@user = User.find(params['user_id'])
		@special = Special.find(params['id'])
	end
	def user_index
		if session[:user_id]
			@user = User.find(session[:user_id])
			@specials = Special.where(user_id: @user.id).order('created_at DESC')
		else
			redirect_to '/' and return
		end
	end
	def edit
		if session[:user_id]
			@user = User.find(session[:user_id])
			@specials = Special.where(user_id: @user.id)
		else
			redirect_to '/' and return
		end
	end
	def update
		@special = Special.find(params['id'])
	    if @special.update(special_params)
	    	flash[:errors] = nil
	    else
	    	flash[:errors] = @special.errors.full_messages
	    end
	    redirect_to "/specials/edit/#{@special.user.username}"
	end
	def destroy
		Special.destroy(params['id'])
		@user = User.find(session[:user_id])
		redirect_to "/#{@user.username}"
	end
	def feature
		@featured = Special.where(user_id: session[:user_id], featured: true).first
		if @featured 
			@featured.update_attribute(:featured, false)
		end
		@new_feature = Special.find(params['id'])
		@new_feature.update_attribute(:featured, true)
		redirect_to "/#{@featured.user.username}"
	end
end
