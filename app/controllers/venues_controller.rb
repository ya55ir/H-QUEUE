class VenuesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show qr_code]
  before_action :set_venue, only: %i[show qr_code]

  # Critères de filtrage de la liste de venues
  # 3 mode de recherche : nearby, geolocated et search
  def index
    if params[:near_venue_id].present?
      @mode            = :nearby
      @reference_venue = Venue.find(params[:near_venue_id])
      @venues          = Venue.nearby_of(@reference_venue).to_a
      @filter_params   = { near_venue_id: @reference_venue.id }
    elsif coordinates.present?
      @mode          = :geolocated
      @venues        = Venue.nearby(*coordinates).to_a
      @filter_params = { latitude: coordinates.first, longitude: coordinates.last }
    else
      @mode          = :search
      @query         = params[:query]
      @venues        = Venue.search(@query)
      @filter_params = { query: @query }
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

  # Coordonnées renvoyées par le bouton de géolocalisation.
  def coordinates
    latitude  = Float(params[:latitude], exception: false)
    longitude = Float(params[:longitude], exception: false)
    return nil unless latitude && longitude

    [latitude, longitude]
  end
end
