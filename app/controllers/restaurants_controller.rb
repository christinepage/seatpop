class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy]

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def restaurant_params
      params.require(:restaurant).permit(:name, :description)
    end

end
