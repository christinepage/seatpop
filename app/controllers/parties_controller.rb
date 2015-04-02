include ActionView::Helpers::DateHelper
class PartiesController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :new, :create, :destroy, :edit, :update]
  before_action :correct_user,   only: [:show,  :edit, :update]
  before_action :correct_restaurant_user,   only: [:create]
  
  def index
    @parties = Party.paginate(page: params[:page])
  end
 
  def new
    @party = Party.new
    @restaurant = Restaurant.find_by(id: params[:id])
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id].to_f)
    @party = @restaurant.parties.build(party_params)
    if @party.save
      flash[:success] = "Party created!"
      redirect_to @restaurant
    else
      flash[:danger] = "Party could NOT be created!"
      render @restaurant
    end
  end
 
  def show
    @party = Party.find(params[:id])
    @restaurant = @party.restaurant
  end
  
  def edit
    @party = Party.find(params[:id])
  end
  
  def update
    @party = Party.find(params[:id])
 
    if @party.update(party_params)
      redirect_to @party
    else
      render 'edit'
    end
  end
  
#  def destroy
 #   Party.find(params[:id]).destroy
  #  redirect_to parties_url
  #end
  
  def destroy
    party = Party.find(params[:id])
    party.restaurant.est_wait_time = Party.first.created_at - Time.now 
    party.restaurant.save!
    party.destroy
    redirect_to(:back)
  end
  
  def sms_table_ready
    @party = Party.find(params[:id])
    # either set flash or append to it, this informational message
    (flash[:notice] ||= "") << " Texting " + @party.phone + "..."

    # let the twilio controller handle the sms
    redirect_to :controller => "twilio", :action => "send_sms",
      :phone =>@party.phone, :sms_body => "Your table is ready"
  end

  private

    def party_params
      params.require(:party).permit(:name, :size, :phone)
    end
    
    def correct_user
      @party = Party.find_by(id: params[:id])
      @restaurant = current_user.restaurants.find_by(id: @party.restaurant_id)
      if @restaurant.nil? 
        flash[:danger] = "Sorry, you are not authorized for this action!"
        redirect_to root_url 
      end
    end
    
    def correct_restaurant_user
      @party = Party.find_by(id: params[:id])
      @restaurant = current_user.restaurants.find_by(id: params[:restaurant_id])
      if @restaurant.nil? 
        flash[:danger] = "Sorry, you are not authorized for this action!"
        redirect_to root_url 
      end
    end
end
