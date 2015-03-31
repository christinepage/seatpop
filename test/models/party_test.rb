require 'test_helper'

class PartyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  
  def setup
    @restaurant = restaurants(:delfina)
    @party = @restaurant.parties.build(name: "Jack", size: '3', phone: '650-533-1296')
  end
  
  
  test "restaurant should be valid" do
    assert @restaurant.valid?
  end
  
  test "party should be valid" do
    assert @party.valid?
  end

  test "restaurant id should be present" do
    @party.restaurant_id = nil
    assert_not @party.valid?
  end
  
  test "name should be present " do
    @party.name = "   "
    assert_not @party.valid?
  end

  test "size should be greater_than 0" do
    @party.size = 0
    assert_not @party.valid?
  end
  
  test "size should be number" do
    @party.size = "abc"
    assert_not @party.valid?
  end
  
  test "phone should be number" do
    @party.phone = "abc"
    assert_not @party.valid?
  end
  
end
