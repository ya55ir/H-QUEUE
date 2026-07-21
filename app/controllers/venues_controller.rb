class VenuesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show qr_code]

  def index
    if params[:near_venue_id].present?
      venue   = Venue.find(params[:near_venue_id])
      @venues = Venue.nearby_of(venue).to_a
      @query  = venue.address
      @near   = true
    else
      @query  = params[:query]
      @venues = Venue.search(@query)
    end
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
