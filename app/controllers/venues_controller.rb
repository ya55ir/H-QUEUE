class VenuesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show qr_code]

  def index
    @venues = if params[:query].present?
                Venue.where("name ILIKE ?", "%#{params[:query]}%")
              else
                # Ne rien afficher par défaut si aucun paramètre de recherche n'est fourni
                Venue.none
              end
  end

  def show
    @venue = Venue.find(params[:id])
  end

  def qr_code
    @venue = Venue.find(params[:id])
    render :show
  end
end
