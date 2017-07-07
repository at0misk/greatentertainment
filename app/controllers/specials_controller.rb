class SpecialsController < ApplicationController
@@fj = {}
	def new
		@user = User.find(session[:user_id])
	end
	def create
		@user = User.find(session[:user_id])
		@special = Special.new(special_params)
		@featured = Special.where(user_id: session[:user_id], featured: true)
		if @featured.length < 4
			@special.update_attribute(:featured, true)
		end
		if @special.save
		else
		end
		redirect_to "/specials/all_specials/#{@user.username}"
	end
	def special_params
		params.require(:special).permit(:title, :depart, :return, :vacancy, :description, :user_id, :image, :price, :featured, :location)
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
		@featured = Special.where(user_id: session[:user_id], featured: true)
		if @featured.length > 3 
			@featured.last.update_attribute(:featured, false)
		end
		@new_feature = Special.find(params['id'])
		@new_feature.update_attribute(:featured, true)
		redirect_to "/specials/all_specials/#{@user.username}"
	end
	def unfeature
		@user = User.find(session[:user_id])
		@featured = Special.find(params['id'])
		@featured.update_attribute(:featured, false)
		@featured.save
		redirect_to "/specials/all_specials/#{@user.username}"
	end
	def fj_create
		@@fj = Fj_special.new(params['title'], params['location'], params['price'], params['flights'], params['date'], params['ref'], params['agent_ref'], params['img_src'])
		redirect_to '/fj_show'
	end
	def fj_show
		if @@fj.present?
			@fj = @@fj
			desc_doc = Nokogiri::HTML(open("#{@fj.ref}"))
			puts @fj.ref
			desc = desc_doc.css('#overviewHotelProperty>p')
			@description = desc.text
			puts @description
			# fail
			@page_user = User.find(session[:page_user_id])
		else
			redirect_to '/'
		end
	end
	def interested_funjet
		@user = User.find(session[:page_user_id])
		# mail here
		redirect_to "/#{@user.username}"
	end
end

class Fj_special
	def initialize(title, location, price, flights, dates, ref, agent_ref, img_src)
		@title = title
		@location = location
		@price = price
		@flights = flights
		@dates = dates
		@ref = ref
		@agent_ref = agent_ref
		@img_src = img_src
	end
	attr_reader :title, :location, :price, :flights, :dates, :ref, :agent_ref, :img_src
end
