class CreateCruises < ActiveRecord::Migration[5.0]
  def change
    create_table :cruises do |t|
      t.string :title
      t.date :departure
      t.date :return
      t.integer :vacancy
      t.string :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
