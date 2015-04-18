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
      flash[:success] = "Party created with id #{@party.id} !"
      redirect_to :controller => "twilio",
        :action => "send_sms",
        :restaurant_id => @party.restaurant_id,
        :phone =>@party.phone,
        :sms_body => "#{@party.name}, Your party id at #{@party.restaurant.name} is: #{@party.id}"
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
  
  def destroy
    party = Party.find(params[:id])
    party.restaurant.est_wait_time = Party.first.created_at - Time.now 
    party.restaurant.save!
    party.destroy
    redirect_to(:back)
  end
  
  def seat
    party = Party.find(params[:id])
    party.restaurant.est_wait_time = Party.first.created_at - Time.now 
    party.restaurant.save!
    party.update_attributes(party_status: PartyStatus.find_by(name: "seated"))
    redirect_to(:back)
  end
  
  def table_ready
    @party = Party.find(params[:id])
    @party.restaurant.est_wait_time = Party.first.created_at - Time.now 
    @party.restaurant.save!
    # either set flash or append to it, this informational message
    (flash[:notice] ||= "") << " Texting " + @party.phone + "..."

    # let the twilio controller handle the sms
    redirect_to :controller => "twilio", :action => "send_sms", :restaurant_id => @party.restaurant_id,
      :phone =>@party.phone, :sms_body => "#{@party.name}, Your table is ready at #{@party.restaurant.name} (party: #{@party.id})"

    @party.update_attributes(party_status: PartyStatus.find_by(name: "seated"))
  end

  def notify
    @party = Party.find(params[:id])
    # either set flash or append to it, this informational message
    (flash[:notice] ||= "") << " Texting " + @party.phone + "..."

    # let the twilio controller handle the sms
    redirect_to :controller => "twilio", :action => "send_sms", :restaurant_id => @party.restaurant_id,
      :phone =>@party.phone, :sms_body => "#{@party.name}, Your table is coming up at #{@party.restaurant.name} (party: #{@party.id})"
  end

  def cancel
    party = Party.find(params[:id])
    party.restaurant.est_wait_time = Party.first.created_at - Time.now 
    party.restaurant.save!
    party.update_attributes(party_status: PartyStatus.find_by(name: "cancelled"))
    redirect_to(:back)
  end
    
  def drop_down
  end
    
  def cancel_party
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
