class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to our site!")
  end

  def contact(user, first, last, message)
  	@user = user
  	@first = first
  	@last = last
  	@message = message
  	mail(to: @user.email, subject: "#{first} #{last} sent you a message!")
  end

  def vacation(user, first, last, airport, email, number, destination, depart_date, return_date, adults, children, comments)
  	@user = user
  	@first = first
  	@last = last
  	@airport = airport
  	@email = email
  	@number = number
  	@destination = destination
  	@depart_date = depart_date
  	@return_date = return_date
  	@adults = adults
  	@children = children
  	@comments = comments
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

end
