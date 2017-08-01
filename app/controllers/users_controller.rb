require 'open-uri'
require 'twilio-ruby'
require 'will_paginate/array'

class UsersController < ApplicationController
skip_before_action :verify_authenticity_token
@@search_users = {}
# Temp test credentials until live account
  @@twilio_sid = 'AC181e8543ebb9d284eb206ac11cf3760e'
  @@twilio_token = '7c7ce2c4ffeee5dc9e56e47bef28620d'
  @@twilio_number = '+15005550006'

  # Handle a POST from our web form and connect a call via REST API
  def call
    @userPhone  = params[:userPhone]
    @salesPhone = params[:salesPhone]

    # Validate contact
    # if contact.valid?

      @client = Twilio::REST::Client.new @@twilio_sid, @@twilio_token
      # Connect an outbound call to the number submitted
      @call = @client.calls.create(
        :from => @@twilio_number,
        :to => @userPhone,
        :url => "http://52.24.144.110/connect/#{@salesPhone}" # Fetch instructions from this URL when the call connects
      )

	# @client = Twilio::REST::Client.new(@@twilio_sid, @@twilio_token)
	# @message = @client.messages.create(
 #    :to => "+19739192402",    # Replace with your phone number
 #    :from => @@twilio_number,
 #    :body => "Hello from Ruby"
 #    )  # Replace with your Twilio number
	# puts "========================"
	# puts @message.subresource_uris

    #   # Let's respond to the ajax call with some positive reinforcement
      @msg = { :message => 'Phone call incoming!', :status => 'ok' }

    # else

    #   # Oops there was an error, lets return the validation errors
    #   @msg = { :message => contact.errors.full_messages, :status => 'ok' }
    # end
    respond_to do |format|
      format.json { render :json => @msg }
    end
 	# @page_user = User.find(session[:page_user_id])
    # redirect_to "/#{@page_user.username}"
  end

  # This URL contains instructions for the call that is connected with a lead
  # that is using the web form.
  def connect
    # Our response to this request will be an XML document in the "TwiML"
    # format. Our Ruby library provides a helper for generating one
    # of these documents
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Thanks for contacting our sales department. Our '\
        'next available representative will take your call.', voice: 'alice')
      r.dial number: params[:sales_number]
    end


    render xml: response.to_s
  end

	def create
		@user = User.find_by(agent_id: params["evolution_id"])
		if @user
			@duplicates = User.where(email: @user.email)
			if @duplicates.length > 1
				User.where("email = ? AND agent_id != ?", "#{@user.email}", params['evolution_id']).delete_all
			end
			random_password = Array.new(6).map { (65 + rand(58)).chr }.join
			@user.password = random_password
			@user.save!
			UserMailer.create_and_deliver_password_change(@user, random_password, "register").deliver_now
			flash[:reg_errors] = "An email has been sent with your temporary password."
		else
			evo_doc = Nokogiri::HTML(open("http://www.cs4000.net/ET/checkid.asp?site=#{params['evolution_id']}"))
			string = evo_doc.css('body').text
			if string == "1|Not Found" || string == "0||N/A|N/A|N/A||"
				flash[:reg_errors] = "No User found with that ID: #{params['evolution_id']}.  Please check the ID and try again."
				redirect_to '/register' and return
			else
				count = 0
				id = ''
				agentname = ''
				phone = ''
				email = ''
				username = ''
				string[2..-1].split("").each do |val|
					if val == "|"
						count += 1
						next
					end
					if count == 0
						id += val
						next
					elsif count == 1
						agentname += val
						next
					elsif count == 2
						phone += val
						next
					elsif count == 3
						email += val
						next
					elsif count == 4
						username += val
						next
					end
				end
				first = agentname[0, agentname.index(" ")]
				last = agentname.sub(/.*? /, '')
				puts first, last, id, agentname, phone, email, username
				random_password = Array.new(6).map { (65 + rand(58)).chr }.join
				@user = User.new(first: first, last: last, agent_id: id, email: email, username: username)
				@user.password = random_password
				@user.save(:validate => false)
				UserMailer.create_and_deliver_password_change(@user, random_password, "register").deliver_now
				flash[:reg_errors] = "An email has been sent with your temporary password."
			end
		end
		redirect_to '/register' and return
	end
	def user_params
  		params.require(:user).permit(:first, :last, :email, :username, :password, :password_confirmation, :phone_number, :avatar, :about, :address, :city, :state, :country, :c2go, :apt, :upline_id, :agent_id, :zip) 
	end
	def show
		@page_user = User.find_by_username(params['username'])
		if @page_user == nil
			flash[:no_user] = "No user found."
			redirect_to '/' and return
		else
			session[:page_user_id] = @page_user.id
			@current_user = User.find(session[:user_id]) if session[:user_id]
		end
		if @current_user && !@current_user.about
			flash[:new] = 'true'
			redirect_to "/#{@current_user.username}/edit" and return
		end
		@blogs = Blog.all.limit(3).order(created_at: "DESC")
		# 
		# Funjet Scrape
		# 
		# doc = Nokogiri::HTML(open("http://www.funjet.com/deals/all-deals"))
		# titles = doc.css('.b-OnSaleProduct__name>a')
		# refs = doc.css('.b-OnSaleCTA__button')
		# locations = doc.css('#OnSaleItemRollUpDetailHeader>h3')
		# prices = doc.css('.b-OnSaleCTA__amount')
		# dates = doc.css('.b-OnSaleItem__details__departures')
		# flights_nights = doc.css('.b-OnSaleCTA__nightsType')
		# photos = doc.css('.b-OnSaleItem__photo>img')
		# agent_ref = doc.css('.b-OnSaleCTA__button')
		# # 
		# @first_ref = "http://www.funjet.com#{refs[0]['href']}"
		# @first_agent_ref = "http://www.funjet.com#{agent_ref[0]['href']}"
		# @first_title = titles[0].text
		# @first_detail_link = titles[0]['href']
		# @first_location = locations[0].text
		# @first_price = prices[0].text
		# @first_location.slice! "Hotels"
		# @first_date = dates[0].text
		# @first_date.slice! "more"
		# @first_date.slice! " for this Price"
		# @first_flights_nights = flights_nights[0].text
		# @first_image_src = photos[0]['ng-src']
		# # 
		# @second_ref = "http://www.funjet.com#{refs[1]['href']}"
		# @second_agent_ref = "http://www.funjet.com#{agent_ref[1]['href']}"
		# @second_title = titles[2].text
		# @second_detail_link = titles[2]['href']
		# @second_location = locations[1].text
		# @second_price = prices[1].text
		# @second_location.slice! "Hotels"
		# @second_date = dates[1].text
		# @second_date.slice! "more"
		# @second_date.slice! " for this Price"
		# @second_flights_nights = flights_nights[1].text
		# @second_image_src = photos[1]['ng-src']
		# #
		# @third_ref = "http://www.funjet.com#{refs[2]['href']}"
		# @third_agent_ref = "http://www.funjet.com#{agent_ref[2]['href']}"
		# @third_title = titles[4].text
		# @third_detail_link = titles[4]['href']
		# @third_location = locations[2].text
		# @third_price = prices[2].text
		# @third_location.slice! "Hotels"
		# @third_date = dates[2].text
		# @third_date.slice! "more"
		# @third_date.slice! " for this Price"
		# @third_flights_nights = flights_nights[2].text
		# @third_image_src = photos[2]['ng-src']
		# # 
		# @fourth_ref = "http://www.funjet.com#{refs[3]['href']}"
		# @fourth_agent_ref = "http://www.funjet.com#{agent_ref[3]['href']}"
		# @fourth_title = titles[6].text
		# @fourth_detail_link = titles[6]['href']
		# @fourth_location = locations[3].text
		# @fourth_price = prices[3].text
		# @fourth_location.slice! "Hotels"
		# @fourth_date = dates[3].text
		# @fourth_date.slice! "more"
		# @fourth_date.slice! " for this Price"
		# @fourth_flights_nights = flights_nights[3].text
		# @fourth_image_src = photos[3]['ng-src']
		# description.each do |val|
		# 	puts val.text
		# end
		# fail
		# 
		# Specials
		hydra = Typhoeus::Hydra.hydra

		first_request = Typhoeus::Request.new("https://www.expedia.com/Honolulu.d1488.Destination-Travel-Guides?rfrr=TG.Destinations.City.POI.1.4")
		second_request = Typhoeus::Request.new("https://www.cheapcaribbean.com/deals/mexico-all-inclusive.html")
		third_request = Typhoeus::Request.new("https://www.ncl.com/vacations/?pageSize=50&numberOfGuests=0&sortBy=Hotdeals&state=null&currentPage=2&")
		first_request.on_complete do |response|
			if response.success?
				doc1 = Nokogiri::HTML(response.response_body)
				@hawaii_hotelname = doc1.css('.hotel-name')[0].text
				@hawaii_href = doc1.css('.tile-content>a')[0]['href']
				@hawaii_price = doc1.css('.price')[0].text
				@hawaii_image_src = doc1.css('.tile-content>a>figure')[0]['data-src']
			end
		end
		second_request.on_complete do |response|
			if response.success?
				doc2 = Nokogiri::HTML(response.response_body)
				@mexico_hotelname = doc2.css('#deal_feat_0_vp_ResortUrl')[0].text
				@mexico_href = "https://www.cheapcaribbean.com" + doc2.css('#deal_feat_0_vp_ResortUrl')[0]['href']
				@mexico_price = doc2.css(".estPrice")[0].text
				@mexico_nights = doc2.css(".numNightsExpr")[0].text
				@mexico_includes = "Including Airfare"
				@mexico_image_src = "https://www.cheapcaribbean.com" + doc2.css(".mobile-top-deals-img-width")[0]['src']
				@mexico_dates = doc2.css(".mobileTallTravelDate")[0].text
				@mexico_dates = @mexico_dates[12..-1]
			end
		end
		third_request.on_complete do |response|
			if response.success?
			doc3 = Nokogiri::HTML(response.response_body)
				@cruise_name = doc3.at('.card-title').text
				@cruise_href = "https://www.ncl.com" + doc3.at('.card-title>a')['href']
				@cruise_price = doc3.at('.price').text
				@cruise_nights = "Avg per person"
				@cruise_image_src = "https://www.ncl.com" + doc3.at('.picture')['src']
			end
		end
		hydra.queue first_request
		hydra.queue second_request
		hydra.queue third_request
		hydra.run # this is a blocking call that returns once all requests are complete
		# 
		@special = Special.where(user_id: @page_user.id, featured: true).first
		if !@special
			@special = Special.find_by(user_id: 1)
		end
		if @current_user && @current_user.id == @page_user.id
			@unapproved_photos = Photo.where(user_id: @current_user.id, allowed: false)
		end
	end
	def test_scrape
		# Parses the call from cs4000
		string = "0|88800|Toni Ward|9252047444|rawdestinations@gmail.com|raw|"
		count = 0
		id = ''
		agentname = ''
		phone = ''
		email = ''
		username = ''
		string[2..-1].split("").each do |val|
			if val == "|"
				count += 1
				next
			end
			if count == 0
				id += val
				next
			elsif count == 1
				agentname += val
				next
			elsif count == 2
				phone += val
				next
			elsif count == 3
				email += val
				next
			elsif count == 4
				username += val
				next
			end
		end
		puts id, agentname, phone, email, username
	end
	def edit
		@user = User.find_by_username(params['username'])
		if @user.id == session[:user_id]
		else
			redirect_to '/'
		end
	end
	def update
		@user = User.find_by_username(params['username'])
		if @user.id == session[:user_id]
		    if @user.update(user_params)
		    	flash[:errors] = nil
		    else
		    	flash[:errors] = @user.errors.full_messages
		    	redirect_to "/#{@user.username}/edit" and return
		    end
		else
		end
		    redirect_to "/#{@user.username}"
	end
	def destroy
		@user = User.find_by_username(params['username'])
		if @user.id == session[:user_id]
			User.find_by_username(params['username']).destroy
			session[:user_id] = nil
		end
		redirect_to '/'
	end
	def requests
		@user = User.find(session[:user_id])
		@topics = Topic.where(user_id: @user.id)
	end
	def request_chat
		@agent = User.find(params['id'])
	end
	def contact
		puts params['user_id']
		@user = User.find(params['user_id'])
		puts params['email']
		puts params['first']
		puts params['last']
		puts params['message']
		if params['subscribe']
			subscription = Subscription.find_by(email: params['email']) || Subscription.new(user_id: session[:page_user_id], email: params['email'], first: params['first'], last: params['last'])
			subscription.save
		end
		UserMailer.contact(@user, params['first'], params['last'], params['email'], params['message']).deliver_now
		flash[:sent_mail] = true
		redirect_to "/#{@user.username}"
	end
	def gallery
		@page_user = User.find_by_username(params['username'])
		if session[:user_id]
			@current_user = User.find(session[:user_id])
			if @current_user && @current_user.id == @page_user.id
				@unapproved_photos = Photo.where(user_id: @current_user.id, allowed: false)
			end
		end
		@photos = Photo.where(user_id: @page_user.id, allowed: true)
	end
	def gallery_upload
		@page_user = User.find_by_username(params['username'])
	end
	def photo_create
		@photo = Photo.new(photo_params)
		if @photo.save
			flash[:photo_confirm] = true
		else
			flash[:photo_confirm] = false
		end
		redirect_to "/gallery/#{@photo.user.username}"
	end
	def photo_params
		params.require(:photo).permit(:image, :user_id, :name, :location, :traveled_on, :description)
	end
	def subscription_params
		params.require(:subscription).permit(:user_id, :email, :first, :last)
	end
	def gallery_edit
		@approved_photos = Photo.where(user_id: session[:user_id], allowed: true).order('updated_at DESC')
		@unapproved_photos = Photo.where(user_id: session[:user_id], allowed: false).order('updated_at DESC')
		@user = User.find(session[:user_id])
	end
	def gallery_update
		@user = User.find(session[:user_id])
		@photo = Photo.find(params['id'])
		if @photo.user.id == session[:user_id]
		    if @photo.update(photo_params)
		    	flash[:errors] = nil
		    else
		    	flash[:errors] = @photo.errors.full_messages
		    end
		else
			redirect_to '/' and return
		end
		    redirect_to "/gallery/#{@user.username}"
	end
	def admins
		session[:user_id] = nil
	end
	def admin_dash
		@user = User.find(session[:user_id])
		if !@user.permod
			redirect_to "/" and return
		end
	end
	def user_search
		@user = User.find(session[:user_id])
		if !@user.permod
			redirect_to "/" and return
		end
		@users = User.where("email LIKE ? OR first LIKE ? OR last LIKE ? OR username LIKE ? OR agent_id LIKE ?", "%#{params['search']}%","%#{params['search']}%","%#{params['search']}%","%#{params['search']}%","%#{params['search']}%")
		if @users
			@@search_users = @users
			redirect_to "/users_found"
		else
			flash[:errors] = "No Users Found"
			redirect_to "/admin_dash" and return
		end
	end
	def users_found
		@user = User.find(session[:user_id])
		if !@user.permod
			redirect_to "/" and return
		end
		if @@search_users.length == 0
			@users = User.none
		else
			@users = @@search_users.paginate(:page => params[:page])
		end
	end
	def recover
		@user = User.find_by(email: params['email'])
		if !@user
			flash[:errors] = "Email not found"
		else
			random_password = Array.new(6).map { (65 + rand(58)).chr }.join
			@user.password = random_password
			@user.save!
			UserMailer.create_and_deliver_password_change(@user, random_password, "forgot").deliver_now
			flash[:errors] = "Email sent"
		end
		redirect_to "/"
	end
	def forgot_password
	end
	def admins_edit_user
		@user = User.find(params[:id])
		if @user
		else
			flash[:errors] = "No User Found"
		end
	end
	def admins_update
		@admin_user = User.find(session[:user_id])
		if !@admin_user.permod
			redirect_to "/" and return
		end
		@user = User.find_by_username(params['username'])
		# if @user.id == session[:user_id]
	    if @user.update(user_params)
	    	flash[:errors] = nil
	    else
	    	flash[:errors] = @user.errors.full_messages
	    	redirect_to "/#{@user.username}/edit" and return
	    end
		# else
		# end
		redirect_to "/#{@user.username}"
	end
	def admins_destroy_user
		@admin_user = User.find(session[:user_id])
		if !@admin_user.permod
			redirect_to "/" and return
		end
		User.find(params[:id]).destroy
		flash[:errors] = "User Destroyed"
		redirect_to "/admin_dash"
	end
	def admins_edit_gallery
		@admin_user = User.find(session[:user_id])
		if !@admin_user.permod
			redirect_to "/" and return
		end
		@approved_photos = Photo.where(user_id: params['id'], allowed: true).order('updated_at DESC')
		@unapproved_photos = Photo.where(user_id: params['id'], allowed: false).order('updated_at DESC')
		@user = User.find(params['id'])
	end
	def admins_gallery_update
		@admin_user = User.find(session[:user_id])
		if !@admin_user.permod
			redirect_to "/" and return
		end
		@photo = Photo.find(params['id'])
		    if @photo.update(photo_params)
		    	flash[:errors] = nil
		    else
		    	flash[:errors] = @photo.errors.full_messages
		    end
		redirect_to "/gallery/#{@photo.user.username}"
	end
	def admins_edit_specials
		@admin_user = User.find(session[:user_id])
		if !@admin_user.permod
			redirect_to "/" and return
		end
		@user = User.find(params['id'])
		@specials = Special.where(user_id: params['id'])
	end
	def admins_feature
		@admin_user = User.find(session[:user_id])
		if !@admin_user.permod
			redirect_to "/" and return
		end
		@special = Special.find(params['id'])
		@user = @special.user
		@featured = Special.where(user_id: @user.id, featured: true)
		if @featured.length > 3 
			@featured.last.update_attribute(:featured, false)
		end
		@new_feature = Special.find(params['id'])
		@new_feature.update_attribute(:featured, true)
		redirect_to "/specials/all_specials/#{@user.username}"
	end
	def admins_unfeature
		@admin_user = User.find(session[:user_id])
		if !@admin_user.permod
			redirect_to "/" and return
		end
		@special = Special.find(params['id'])
		@user = @special.user
		@featured = Special.find(params['id'])
		@featured.update_attribute(:featured, false)
		@featured.save
		redirect_to "/specials/all_specials/#{@user.username}"
	end
	def import_users
		@admin_user = User.find(session[:user_id])
		if !@admin_user.permod
			redirect_to "/" and return
		end
		User.import(params[:file])
		redirect_to '/admin_dash'
		flash[:imported] = "Users Imported"
	end
	def admins_active_users
		@@search_users = User.where.not(about: '')
		redirect_to "/users_found"
	end
	def admins_today_users
		@@search_users = User.where("updated_at >= ?", Time.zone.now.beginning_of_day)
		redirect_to "/users_found"
	end
	def admins_beta_testers
		@@search_users = []
		ids = [88800, 23350, 91946, 68841, 94627, 60938, 79574, 18117, 18381, 84345, 30618, 90755, 35037, 34154, 17462, 55338, 40281, 18646, 68509, 46735, 17321, 31822, 36230, 79228, 94852, 65950, 68823, 30339, 31602, 24850, 41994, 44461, 54787, 31404, 36365, 81887, 81181, 71207, 79937, 86524, 92705, 69748, 32777, 44395, 72499, 24907, 10000, 72628, 62994, 76747, 19634, 77583, 11561, 46362, 27371, 63981, 84606]
		ids.each do |val|
			@user = User.find_by(agent_id: val)
			@@search_users << @user
		end
		redirect_to "/users_found"
	end
	def beta_test
		ids = [88800, 23350, 91946, 68841, 94627, 60938, 79574, 18117, 18381, 84345, 30618, 90755, 35037, 34154, 17462, 55338, 40281, 18646, 68509, 46735, 17321, 31822, 36230, 79228, 94852, 65950, 68823, 30339, 31602, 24850, 41994, 44461, 54787, 31404, 36365, 81887, 81181, 71207, 79937, 86524, 92705, 69748, 32777, 44395, 72499, 24907, 10000, 72628, 62994, 76747, 19634, 77583, 11561, 46362, 27371, 63981, 84606]
		flash[:beta_errors] = []
		ids.each do |val|
			@user = User.find_by(agent_id: val)
			if @user
				random_password = Array.new(6).map { (65 + rand(58)).chr }.join
				@user.password = random_password
				@user.save!
				UserMailer.beta_test(@user, random_password).deliver_now
			else
				evo_doc = Nokogiri::HTML(open("http://www.cs4000.net/ET/checkid.asp?site=#{val}"))
				string = evo_doc.css('body').text
				if string == "1|Not Found" || string == "0||N/A|N/A|N/A||"
					flash[:beta_errors] << "No User found with ID of #{val}"
				else
					count = 0
					id = ''
					agentname = ''
					phone = ''
					email = ''
					username = ''
					string[2..-1].split("").each do |val|
						if val == "|"
							count += 1
							next
						end
						if count == 0
							id += val
							next
						elsif count == 1
							agentname += val
							next
						elsif count == 2
							phone += val
							next
						elsif count == 3
							email += val
							next
						elsif count == 4
							username += val
							next
						end
					end
					first = agentname[0, agentname.index(" ")]
					last = agentname.sub(/.*? /, '')
					puts first, last, id, agentname, phone, email, username
					random_password = Array.new(6).map { (65 + rand(58)).chr }.join
					@user = User.new(first: first, last: last, agent_id: id, email: email, username: username)
					@user.password = random_password
					@user.save(:validate => false)
					UserMailer.beta_test(@user, random_password).deliver_now
				end
			end
		end
		redirect_to "/"
	end
	def clean_testers
		ids = [88800, 23350, 91946, 68841, 94627, 60938, 79574, 18117, 18381, 84345, 30618, 90755, 35037, 34154, 17462, 55338, 40281, 18646, 68509, 46735, 17321, 31822, 36230, 79228, 94852, 65950, 68823, 30339, 31602, 24850, 41994, 44461, 54787, 31404, 36365, 81887, 81181, 71207, 79937, 86524, 92705, 69748, 32777, 44395, 72499, 24907, 10000, 72628, 62994, 76747, 19634, 77583, 11561, 46362, 27371, 63981, 84606]
		ids.each do |val|
			@user = User.find_by(agent_id: val)
			@duplicates = User.where(email: @user.email)
			if @duplicates.length > 1
				User.where("email = ? AND agent_id != ?", "#{@user.email}", "#{val}").delete_all
			end
		end
		redirect_to '/'
	end
end
