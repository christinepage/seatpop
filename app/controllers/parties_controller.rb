class PartiesController < ApplicationController
  def index
    @parties = Party.paginate(page: params[:page])
  end
 
  def new
    @party = Party.new
  end

  def create
    @party = Party.new(party_params)
    if @party.save
      redirect_to @party
    else
      render 'new'
    end
  end
 
  def show
    @party = Party.find(params[:id])
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
    Party.find(params[:id]).destroy
    redirect_to parties_url
  end
  
  private

    def party_params
      params.require(:party).permit(:name, :size, :phone)
    end
end
