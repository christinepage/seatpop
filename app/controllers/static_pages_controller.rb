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
  
  

  def check_status
    if params[:search_party_name] && params[:search_party_phone] && params[:search_party_id]
      @party = Party.find_by(name: params[:search_party_name], phone: params[:search_party_phone].scan(/[0-9]/).join, id: params[:search_party_id])      
      @party_placement = (@party ? @party.waiting_list_position : 0)
    else
      
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
