class VenuesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show qr_code]
  before_action :set_venue, only: %i[show qr_code]

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
    @queue_count = @venue.current_queue_count
  end

  def qr_code
  end

  private

  def set_venue
    @venue = Venue.find(params[:id])
  end
end
