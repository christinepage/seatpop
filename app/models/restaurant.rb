class Restaurant < ActiveRecord::Base
  has_many :parties, dependent: :destroy
end
