class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to our site!")
  end

  def contact(user, first, last, email, message)
  	@user = user
  	@first = first
  	@last = last
  	@message = message
    @email = email
  	mail(to: @user.email, subject: "#{first} #{last} sent you a message!")
  end

  def vacation(user, first, last, email, phone, departure, return_date, flexible, explore_options, other_explore, vibe_options, other_vibe, activity_options, other_activity, view_options, other_view, include_options, other_include, budget, star_options, rentalcar_options, other_rentalcar, party_size, traveler_type_options, occasion_options, other_occasion, comments, contact_preference)
  	@user = user
  	@first = first
  	@email = email
    @phone = phone
    @depart_date = departure
    @return_date = return_date
    @flexible = flexible
    @explore_options = explore_options
    @explore_other = other_explore
    @vibe_options = vibe_options
    @vibe_other = other_vibe
    @activity_options = activity_options
    @activity_other = other_activity
    @view_options = view_options
    @view_other = other_view
    @include_options = include_options
    @include_other = other_include
    @budget = budget
    @star_options = star_options
    @rentalcar_options = rentalcar_options
    @rentalcar_other = other_rentalcar
    @party_size = party_size
    @traveler_type_options = traveler_type_options
    @occasion_options = occasion_options
    @occasion_other = other_occasion
    @comments = comments
    @contact_preference = contact_preference
  	mail(to: @user.email, subject: "#{first} #{last} wants to go on vacation!")
  end

  def user_special(user, special, first, last, email, number, message)
  	@user = user
  	@special = special
  	@first = first
  	@last = last
  	@email = email
  	@number = number
  	@message = message
  	mail(to: @user.email, subject: "#{first} #{last} is interested in your special!")
  end

  def funjet_special(user, ref, first, last, email, number, message)
  	@user = user
  	@ref = ref
  	@first = first
  	@last = last
  	@email = email
  	@number = number
  	@message = message
  	mail(to: @user.email, subject: "#{first} #{last} is interested in your special!")
  end

  def mail_subscribers(user, recipient, subject, message)
    @user = user
    @recipient = recipient
    @message = message
    mail(to: recipient.email, subject: "#{subject}")
  end

  def create_and_deliver_password_change(user, random_password, from)
    @from = from
    @user = user
    @random_password = random_password
    if from == "forgot"
      mail(to: "#{@user.email}", subject: 'Password Recovery')
    elsif from == "register"
      mail(to: "#{@user.email}", subject: 'Account Registration')
    end
  end

end
