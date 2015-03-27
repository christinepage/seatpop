class Party < ActiveRecord::Base
  belongs_to :restaurant
  
  validates :name,  presence: true, length: { maximum: 50 }
  #FUTURE: allow restaurants to set max party size and validate that dynamically
  validates :size,  presence: true, length: { maximum: 50 }
  VALID_PHONE_REGEX = /\+?\(?\d{2,4}\)?[\d\s-]{3,}/i
  validates :phone, length: { maximum: 50 },
                    format: { with: VALID_PHONE_REGEX },
                    uniqueness: true
end
