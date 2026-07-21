class VenuesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show qr_code]
  before_action :set_venue, only: %i[show qr_code]

  def index
    @venues = Venue.search(params[:query])
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
