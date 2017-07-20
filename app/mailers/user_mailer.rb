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

  def vacation(user, first, last, airport, return_airport, budget, email, number, destination, depart_date, return_date, adults, children, comments)
  	@user = user
  	@first = first
  	@last = last
  	@airport = airport
    @budget = budget
    if !@return_airport
      @return_airport = airport
    else
      @return_airport = return_airport
    end
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

  def mail_subscribers(user, recipient, subject, message)
    @user = user
    @recipient = recipient
    @message = message
    mail(to: recipient.email, subject: "#{subject}")
  end

  def create_and_deliver_password_change(user, random_password)
    @user = user
    @random_password = random_password
    mail(to: "#{@user.email}", subject: 'Password Recovery')
  end

end
