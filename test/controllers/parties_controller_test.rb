require 'test_helper'

class PartiesControllerTest < ActionController::TestCase

  def setup
    @party = parties(:emma)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Party.count' do
      post :create, party: { name: "Anthony", size: 3 }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Party.count' do
      delete :destroy, id: @party
    end
    assert_redirected_to login_url
  end
  
  test "should redirect edit when not logged in" do
    assert_no_difference 'Party.count' do
      get :edit, id: @party
    end
    assert_redirected_to login_url
  end
  
end
