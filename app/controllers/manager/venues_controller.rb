module Manager
  class VenuesController < ApplicationController
    before_action :ensure_manager!

    def index
      @venues = Venue.all
    end

    def show
      @venue = Venue.find(params[:id])
    end

    private

    def ensure_manager!
      redirect_to root_path, alert: "Accès réservé aux managers" unless current_user.is_manager?
    end
  end
end
