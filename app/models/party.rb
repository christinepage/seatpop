class Party < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :party_status
  before_validation :format_phone

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
    if self.new_record?
      self.party_status_id ||= 1
      self.token ||= random_uniq_token
    end
  end
  
  def format_phone
    self.phone = self.phone.scan(/[0-9]/).join
  end

  # generates a unique token for a party restaurant id + random num between 0 and 999
  def random_uniq_token
    potential_tok = 0
    tries = 0
    loop do 
      tries += 1
      potential_tok = self.restaurant_id * 1000 + SecureRandom.random_number(1000)
      break if Party.where(token: potential_tok, party_status_id: 1).count == 0
      if tries > 100
        raise RuntimeError, "Cannot find unique token for party", caller
      end
    end
    potential_tok
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
