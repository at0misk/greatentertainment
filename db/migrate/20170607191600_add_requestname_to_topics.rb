class AddRequestnameToTopics < ActiveRecord::Migration[5.0]
  def change
  	add_column :topics, :request_name, :string
  end
end
