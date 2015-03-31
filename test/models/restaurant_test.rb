require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase

  def setup
    @restaurant = Restaurant.create(name: "La Nebbia")
  end
  
  test "associated parties should be destroyed" do
    @restaurant.save
    @restaurant.parties.create!(name: "Sara", size: 3, phone: '333-333-3333')
    assert_difference 'Party.count', -1 do
      @restaurant.destroy
    end
  end
end
