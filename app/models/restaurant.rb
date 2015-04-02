class Restaurant < ActiveRecord::Base
  has_many :parties, dependent: :destroy
  has_many :restaurants_users
  has_many :users, :through => :restaurants_users, :source => :user
  mount_uploader :picture, PictureUploader
  validate  :picture_size
  
  def waitlist 
    Party.where("restaurant_id = ?", id)
  end
  
  def self.search(query)
    where("name like ?", "%#{query}%") 
  end


  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 15.megabytes
        errors.add(:picture, "should be less than 15MB")
      end
    end
end
