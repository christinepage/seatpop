class StaticPagesController < ApplicationController
  def home
    @restaurant = current_user.restaurants.build if logged_in?
  end

  def search
    if params[:search]
      @restaurants = Restaurant.search(params[:search]).paginate(page: params[:page])
    else
      @restaurants = Restaurant.paginate(page: params[:page])
    end
  end
  
  def staff_home
    @restaurant = current_user.restaurants.first
  end
  
  def help
  end
  
  def about
  end
  
  def contact
  end
end
