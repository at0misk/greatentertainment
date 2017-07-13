class CreateCommissions < ActiveRecord::Migration[5.0]
  def change
    create_table :commissions do |t|
      t.references :user, foreign_key: true
      t.string :first
      t.string :last
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :traveler_names
      t.string :traveler_phone
      t.string :traveler_email
      t.date :depart
      t.date :return
      t.string :itinerary
      t.string :ticket
      t.string :supplier
      t.string :airline
      t.string :hotel
      t.string :car_rental
      t.string :form
      t.integer :last_4
      t.string :comments

      t.timestamps
    end
  end
end
