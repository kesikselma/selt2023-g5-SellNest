class ListingsController < ApplicationController
  def edit
    @listing = Listing.find params[:id]
  end

  def new
    @listing = Listing.new
    @tags = Tag.all
  end

  def show
    id = params[:id]
    @listing = Listing.find(id)
  end

  def listing_params
    params.require(:listing).permit(:name, :description, :price, :user_id, photos: [])
  end

  def create
    @listing = Listing.new(listing_params)

    if params[:listing][:photos].present?
      params[:listing][:photos].each do |photo|
        @listing.photos.attach(photo)
      end
    end

    if @listing.save
      flash[:notice] = "#{@listing.name} was successfully created."
      redirect_to listings_path
    else
      render 'new'
    end
  end



  def index
    # Start with all listings or search results
    @listings = params[:search] ? Listing.search_by_title(params[:search]).where(is_sold: false) : Listing.where(is_sold: false)

    # Sorting logic
    case params[:sort]
    when 'price_asc'
      @listings = @listings.order(price: :asc)
    when 'price_desc'
      @listings = @listings.order(price: :desc)
    when 'newest'
      @listings = @listings.order(created_at: :desc)
    when 'oldest'
      @listings = @listings.order(created_at: :asc)
    end

    # Advanced filtering logic
    @listings = @listings.where('price >= ?', params[:min_price].to_f) if params[:min_price].present?
    @listings = @listings.where('price <= ?', params[:max_price].to_f) if params[:max_price].present?
    # Add more filters as needed

    # Finally, render the index view
    render :index
  end


  def update
    @listing = Listing.find(params[:id])
    if @listing.update(listing_params)
      flash[:notice] = "#{@listing.name} was successfully updated."
      redirect_to listings_path
    else
      render 'edit'
    end
  end

  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
    flash[:notice] = "Listing deleted."
    redirect_to listings_path
  end

end
