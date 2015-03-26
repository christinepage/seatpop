class AddRestaurantRefToParties < ActiveRecord::Migration
  def change
    add_reference :parties, :restaurant, index: true
    add_foreign_key :parties, :restaurants
  end
end
