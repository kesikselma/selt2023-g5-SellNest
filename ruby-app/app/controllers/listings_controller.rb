class ListingsController < ApplicationController
  def edit
    @listing = Listing.find params[:id]
  end

  def new
  end

  def listing_params
    params.require(:listing).permit(:name, :photos, :description, :price, :sellerID)
  end

  def create
    @listing = Listing.create!(listing_params)
    flash[:notice] = "#{@Listing.name} was successfully created."
    redirect_to listings_path
  end

  def index
    @listings = Listing.all
    render :index
  end

  def update  # does not actually update info at the moment
    index
  end
end
