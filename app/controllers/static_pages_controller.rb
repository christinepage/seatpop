class StaticPagesController < ApplicationController
  def home
    @restaurant = current_user.restaurants.build if logged_in?
    @restaurant_list_items = current_user.restaurant_list.paginate(page: params[:page])
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
