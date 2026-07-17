class VenuesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show qr_code]

  def index
    @venues = Venue.search(params[:query])
  end

  def show
    @venue = Venue.find(params[:id])
    @queue_count = @venue.current_queue_count
  end

  def qr_code
    @venue = Venue.find(params[:id])
    render :show
  end
end
