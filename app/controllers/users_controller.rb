require 'open-uri'

class UsersController < ApplicationController
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

      # @client = Twilio::REST::Client.new @@twilio_sid, @@twilio_token
      # # Connect an outbound call to the number submitted
      # @call = @client.calls.create(
      #   :from => @@twilio_number,
      #   :to => @userPhone,
      #   :url => "http://52.24.144.110/connect/#{@salesPhone}" # Fetch instructions from this URL when the call connects
      # )

	@client = Twilio::REST::Client.new(@@twilio_sid, @@twilio_token)
	@message = @client.messages.create(
    :to => "+19739192402",    # Replace with your phone number
    :from => @@twilio_number,
    :body => "Hello from Ruby"
    )  # Replace with your Twilio number
	puts "========================"
	puts @message.subresource_uris

    #   # Let's respond to the ajax call with some positive reinforcement
    #   @msg = { :message => 'Phone call incoming!', :status => 'ok' }

    # else

    #   # Oops there was an error, lets return the validation errors
    #   @msg = { :message => contact.errors.full_messages, :status => 'ok' }
    # end
    # respond_to do |format|
    #   format.json { render :json => @msg }
    # end
 	@page_user = User.find(session[:page_user_id])
    redirect_to "/#{@page_user.username}"
  end

  # This URL contains instructions for the call that is connected with a lead
  # that is using the web form.
  def connect
    # Our response to this request will be an XML document in the "TwiML"
    # format. Our Ruby library provides a helper for generating one
    # of these documents
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Thanks for contacting our sales department. Our ' +
        'next available representative will take your call.', :voice => 'alice'
      r.Dial params[:sales_number]
    end
    render text: response.text
  end

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
  		params.require(:user).permit(:first, :last, :email, :username, :password, :password_confirmation, :phone_number, :avatar, :about, :address, :city, :state, :country) 
	end
	def show
		@page_user = User.find_by_username(params['username'])
		if @page_user == nil
			flash[:no_user] = "No user found."
			redirect_to '/' and return
		else
			session[:page_user_id] = @page_user.id
			@current_user = User.find(session[:user_id]) if session[:user_id]
			@request_count = Topic.where(user_id: session[:user_id]).length if session[:user_id]
				if @request_count && @request_count > 0
					@page_user_topics = Topic.where(user_id: session[:user_id])
				end
		end
		@latest = Blog.where(user_id: @page_user.id).last
		@cruise = Cruise.where(user_id: @page_user.id).last
		@blogs = Blog.all.limit(2).order(created_at: "DESC")
		# 
		# Funjet Scrape
		# 
		doc = Nokogiri::HTML(open("http://www.funjet.com/deals/all-deals"))
		titles = doc.css('.b-OnSaleProduct__name>a')
		refs = doc.css('.b-OnSaleCTA__button')
		locations = doc.css('#OnSaleItemRollUpDetailHeader>h3')
		prices = doc.css('.b-OnSaleCTA__amount')
		dates = doc.css('.b-OnSaleItem__details__departures')
		flights_nights = doc.css('.b-OnSaleCTA__nightsType')
		photos = doc.css('.b-OnSaleItem__photo>img')
		agent_ref = doc.css('.b-OnSaleCTA__button')
		# 
		@first_ref = "http://www.funjet.com#{refs[0]['href']}"
		@first_agent_ref = "http://www.funjet.com#{agent_ref[0]['href']}"
		@first_title = titles[0].text
		@first_detail_link = titles[0]['href']
		@first_location = locations[0].text
		@first_price = prices[0].text
		@first_location.slice! "Hotels"
		@first_date = dates[0].text
		@first_date.slice! "more"
		@first_date.slice! " for this Price"
		@first_flights_nights = flights_nights[0].text
		@first_image_src = photos[0]['ng-src']
		# 
		@second_ref = "http://www.funjet.com#{refs[1]['href']}"
		@second_agent_ref = "http://www.funjet.com#{agent_ref[1]['href']}"
		@second_title = titles[2].text
		@second_detail_link = titles[2]['href']
		@second_location = locations[1].text
		@second_price = prices[1].text
		@second_location.slice! "Hotels"
		@second_date = dates[1].text
		@second_date.slice! "more"
		@second_date.slice! " for this Price"
		@second_flights_nights = flights_nights[1].text
		@second_image_src = photos[1]['ng-src']
		#
		@third_ref = "http://www.funjet.com#{refs[2]['href']}"
		@third_agent_ref = "http://www.funjet.com#{agent_ref[2]['href']}"
		@third_title = titles[4].text
		@third_detail_link = titles[4]['href']
		@third_location = locations[2].text
		@third_price = prices[2].text
		@third_location.slice! "Hotels"
		@third_date = dates[2].text
		@third_date.slice! "more"
		@third_date.slice! " for this Price"
		@third_flights_nights = flights_nights[2].text
		@third_image_src = photos[2]['ng-src']
		# 
		@fourth_ref = "http://www.funjet.com#{refs[3]['href']}"
		@fourth_agent_ref = "http://www.funjet.com#{agent_ref[3]['href']}"
		@fourth_title = titles[6].text
		@fourth_detail_link = titles[6]['href']
		@fourth_location = locations[3].text
		@fourth_price = prices[3].text
		@fourth_location.slice! "Hotels"
		@fourth_date = dates[3].text
		@fourth_date.slice! "more"
		@fourth_date.slice! " for this Price"
		@fourth_flights_nights = flights_nights[3].text
		@fourth_image_src = photos[3]['ng-src']
		# description.each do |val|
		# 	puts val.text
		# end
		# fail
		# 
		# Specials
		# 
		@specials = Special.where(user_id: @page_user.id, featured: true)
		if @current_user && @current_user.id == @page_user.id
			@unapproved_photos = Photo.where(user_id: @current_user.id, allowed: false)
		end
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
			subscription = Subscription.new(user_id: session[:user_id], email: params['email'], first: params['first'], last: params['last'])
			subscription.save
		end
		UserMailer.contact(@user, params['first'], params['last'], params['message']).deliver_now
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
		if @photo.id == session[:user_id]
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
	end
	def user_search
		@users = User.where("email LIKE ? OR first LIKE ? OR last LIKE ? OR username LIKE ?", "%#{params['search']}%","%#{params['search']}%","%#{params['search']}%","%#{params['search']}%")
		if @users
			@@search_users = @users
			redirect_to "/users_found"
		else
			flash[:errors] = "No Users Found"
			redirect_to "/admin_dash" and return
		end
	end
	def users_found
		@users = @@search_users
	end
	def recover
		@user = User.find_by(email: params['email'])
		if !@user
			flash[:errors] = "Email not found"
		else
			random_password = Array.new(10).map { (65 + rand(58)).chr }.join
			@user.password = random_password
			@user.save!
			UserMailer.create_and_deliver_password_change(@user, random_password).deliver_now
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
		User.find(params[:id]).destroy
		flash[:errors] = "User Destroyed"
		redirect_to "/admin_dash"
	end
	def admins_edit_gallery
		@approved_photos = Photo.where(user_id: params['id'], allowed: true).order('updated_at DESC')
		@unapproved_photos = Photo.where(user_id: params['id'], allowed: false).order('updated_at DESC')
		@user = User.find(params['id'])
	end
	def admins_gallery_update
		@photo = Photo.find(params['id'])
		    if @photo.update(photo_params)
		    	flash[:errors] = nil
		    else
		    	flash[:errors] = @photo.errors.full_messages
		    end
		redirect_to "/gallery/#{@photo.user.username}"
	end
	def admins_edit_specials
		@user = User.find(session[:user_id])
		@specials = Special.where(user_id: @user.id)
	end
	def admins_feature
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
		@special = Special.find(params['id'])
		@user = @special.user
		@featured = Special.find(params['id'])
		@featured.update_attribute(:featured, false)
		@featured.save
		redirect_to "/specials/all_specials/#{@user.username}"
	end
end
