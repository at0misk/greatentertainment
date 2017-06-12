class CreateSpecials < ActiveRecord::Migration[5.0]
  def change
    create_table :specials do |t|
      t.string :title
      t.date :depart
      t.date :return
      t.integer :vacancy
      t.string :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
