class CreateJoinTableRestaurantsUsers < ActiveRecord::Migration
  def change
    create_join_table :restaurants, :users do |t|
      # t.index [:restaurant_id, :user_id]
      # t.index [:user_id, :restaurant_id]
    end
  end
end
