require 'action_view'
include ActionView::Helpers::DateHelper

class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy, :estwait]
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :admin_user,     only: :destroy
  
  
 # def index
  #  if params[:search]
   #   @restaurants = Restaurant.search(params[:search]).order("created_at DESC")
    #else
     # @restaurants = Restaurant.order("created_at DESC")
    #end
  #end
    
  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.users.append(current_user)
    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully created.' }
        format.json { redirect_to restaurants_url, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
        
      end
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @party = @restaurant.parties.build if logged_in?
    @waitlist_items = @restaurant.waitlist.paginate(page: params[:page])
    @seatlist_items = @restaurant.seatlist.paginate(page: params[:page])
  end

  def edit

  end

  def update
   respond_to do |format|
      if @restaurant.update(restaurant_params)
        format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully updated.' }
        format.json { render :index, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @restaurants = Restaurant.paginate(page: params[:page])
  end


  def destroy
    @restaurant.destroy
    respond_to do |format|
      format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def estwait
    if @restaurant.est_wait_time 
        ret_data = {waittimestr: "#{distance_of_time_in_words(@restaurant.est_wait_time)}"}
    else
        ret_data = {waittimestr: "No wait!"}
    end

    ret_data[:waitlistlen] = @restaurant.waitlist.length.to_s + " waiting"

    logger.debug "estwait ret_data: #{ret_data.to_json}"
    respond_to do |format|
      format.html { render html: ret_data[:waittimestr] }
      format.json { render json: ret_data.to_json }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def restaurant_params
      params.require(:restaurant).permit(:name, :description, :picture)
    end
    
    def correct_user
      @restaurant = current_user.restaurants.find_by(id: params[:id])
      redirect_to root_url if @restaurant.nil?
    end

end
