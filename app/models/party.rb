class Party < ActiveRecord::Base
  belongs_to :restaurant
  default_scope -> { order(created_at: :asc) }
  validates :restaurant_id, presence: true
  
  validates :name,  presence: true, length: { maximum: 50 }
  #FUTURE: allow restaurants to set max party size and validate that dynamically
  validates_numericality_of :size,  presence: true, length: { maximum: 50 }, greater_than: 0 
  VALID_PHONE_REGEX = /1?[ -.]?\(?\d{3}\)?[ -.]?\d{3}[ -.]?\d{4}[ extension\.]*\d*/i
  validates :phone, length: { maximum: 50 },
                    format: { with: VALID_PHONE_REGEX },
                    uniqueness: true
  
end
