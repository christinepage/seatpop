class Restaurant < ActiveRecord::Base
  has_many :parties, dependent: :destroy
  has_many :restaurants_users
  has_many :users, :through => :restaurants_users, :source => :user
  mount_uploader :picture, PictureUploader
  
  def waitlist 
    Party.where("restaurant_id = ?", id)
  end
  
end
