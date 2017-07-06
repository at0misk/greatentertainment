# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome
    user = OpenStruct.new(email: "demo@example.com", name: "John Doe")
    UserMailer.welcome(user)
  end
  def contact
    user = OpenStruct.new(email: "demo@example.com", first: "John", last: "Doe")
    UserMailer.contact(user, "Kevin", "Taylor", "Hello! asdf asdf asdf")
  end
  def vacation
    user = OpenStruct.new(email: "demo@example.com", first: "John", last: "Doe")
    UserMailer.vacation(user, "Kevin", "Taylor", "JFK", "ktp925@gmail.com", "973-919-2402", "Hawaii", "01/01/2020", "02/02/2020", "2", "0", "Hello! asdf asdf asdf")
  end
  def user_special
    user = OpenStruct.new(email: "demo@example.com", first: "John", last: "Doe")
    special = OpenStruct.new(title: "Alaskan Cruise")
    UserMailer.user_special(user, special, "Kevin", "Taylor", "ktp925@gmail.com", "973-919-2402", "Hello! asdf asdf asdf")
  end
  def funjet_special
    user = OpenStruct.new(email: "demo@example.com", first: "John", last: "Doe")
    UserMailer.funjet_special(user, "http://www.funjet.com/Deals/HotelOnly.aspx?onsaleid=470953&nights=5&price=70", "Kevin", "Taylor", "ktp925@gmail.com", "973-919-2402", "Hello! asdf asdf asdf")
  end
end