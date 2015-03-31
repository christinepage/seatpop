class StaticPagesController < ApplicationController
  def home
    @restaurant = current_user.restaurants.build if logged_in?
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
