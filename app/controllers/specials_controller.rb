class SpecialsController < ApplicationController
@@fj = {}
	def new
		@user = User.find(session[:user_id])
	end
	def create
		@user = User.find(session[:user_id])
		@special = Special.new(special_params)
		@featured = Special.where(user_id: session[:user_id], featured: true)
		if @featured.length < 1
			@special.update_attribute(:featured, true)
		end
		if @special.save
		else
			flash[:errors] = @special.errors.full_messages
			redirect_to "/specials/new/#{@user.username}" and return
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
		if @featured.length > 0
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
		@@fj = Fj_special.new(params['title'], params['location'], params['price'], params['flights'], params['date'], params['ref'], params['agent_ref'], params['img_src'], params['includes'])
		redirect_to '/fj_show'
	end
	def fj_show
		if @@fj.present?
			@fj = @@fj
			desc_doc = Nokogiri::HTML(open("#{@fj.ref}"))
			if @fj.location == "Hawaii"
				@description = desc_doc.css('div')[35].text.gsub("\n", "")
				puts @description.gsub("\t", "")
				# fail
			else
				@description = desc_doc.css('#overviewHotelProperty').text

			end
			# fail
			@page_user = User.find(session[:page_user_id])
		else
			redirect_to '/'
		end
	end
	def interested_funjet
		@user = User.find(session[:page_user_id])
		# mail here
		UserMailer.funjet_special(@user, params['agent_ref'], params['first'], params['last'], params['email'], params['phone_number'], params['message']).deliver_now
		flash[:sent_mail] = true
		redirect_to "/#{@user.username}"
	end
	def hawaii
		@user = User.find(session[:page_user_id])
		doc = Nokogiri::HTML(open(params['url']))
	end
end

class Fj_special
	def initialize(title, location, price, flights, dates, ref, agent_ref, img_src, includes)
		@title = title
		@location = location
		@price = price
		@flights = flights
		@dates = dates
		@ref = ref
		@agent_ref = agent_ref
		@img_src = img_src
		@includes = includes
	end
	attr_reader :title, :location, :price, :flights, :dates, :ref, :agent_ref, :img_src, :includes
end
