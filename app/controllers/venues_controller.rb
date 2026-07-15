class VenuesController < ApplicationController
  def index
    @venues = Venue.all
    @venues = @venues.where("name ILIKE ?", "%#{params[:query]}%") if params[:query].present?
  end

  def show
    @venue = Venue.find(params[:id])
  end

  def qr_code
    @venue = Venue.find(params[:id])
    render :show
  end
end
