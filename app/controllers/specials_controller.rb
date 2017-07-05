class SpecialsController < ApplicationController
@@fj = {}
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
		redirect_to "/specials/#{@special.user.id}/#{@special.id}"
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
		redirect_to "/specials/all_specials/#{@user.username}"
	end
	def feature
		@user = User.find(session[:user_id])
		@featured = Special.where(user_id: session[:user_id], featured: true).first
		if @featured 
			@featured.update_attribute(:featured, false)
		end
		@new_feature = Special.find(params['id'])
		@new_feature.update_attribute(:featured, true)
		redirect_to "/#{@user.username}"
	end
	def fj_create
		@@fj = Fj_special.new(params['title'], params['location'], params['price'], params['flights'], params['date'], params['ref'], params['img_src'])
		redirect_to '/fj_show'
	end
	def fj_show
		if @@fj.present?
			@fj = @@fj
			desc_doc = Nokogiri::HTML(open("#{@fj.ref}"))
			desc = desc_doc.css('#overviewHotelProperty>p')
			@description = desc.text
			@page_user = User.find(session[:page_user_id])
		else
			redirect_to '/'
		end
	end
end

class Fj_special
	def initialize(title, location, price, flights, dates, ref, img_src)
		@title = title
		@location = location
		@price = price
		@flights = flights
		@dates = dates
		@ref = ref
		@img_src = img_src
	end
	attr_reader :title, :location, :price, :flights, :dates, :ref, :img_src
end
