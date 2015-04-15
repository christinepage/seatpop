class Party < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :party_status

  default_scope -> { order(created_at: :asc) }
  validates :restaurant_id, presence: true
  
  validates :name,  presence: true, length: { maximum: 50 }
  #FUTURE: allow restaurants to set max party size and validate that dynamically
  validates_numericality_of :size,  presence: true, length: { maximum: 50 }, greater_than: 0 
  VALID_PHONE_REGEX = /(1?[ -.]?\(?\d{3}\)?[ -.]?\d{3}[ -.]?\d{4}[ extension\.]*\d{0,5})/i
  validates :phone, length: { maximum: 50 },
                    allow_blank: true,
                    format: { with: VALID_PHONE_REGEX }

  after_initialize :init
  
  def init
    self.party_status_id ||= 1
  end

  def status
    return self.party_status.name
  end

  def waiting?
    self.status == "waiting" ? true : false
  end

  def waiting_list_position
    if self.waiting?
      Party.where(restaurant:self.restaurant, party_status_id: 1).where(["created_at <= ?", self.created_at]).count
    else
      0
    end
  end
  
end
