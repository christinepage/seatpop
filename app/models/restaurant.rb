class Restaurant < ActiveRecord::Base
  has_many :parties, dependent: :destroy
  has_and_belongs_to_many :users 
  
  
  def waitlist #feed
    Party.where("restaurant_id = ?", id)
  end
  
end
