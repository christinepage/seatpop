class RestaurantsUser < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :restaurant, class_name: "Restaurant"
end
