module Manager
  class VenuesController < ApplicationController
    before_action :ensure_manager!

    def index
      @venues = Venue.all
    end

    def show
      @venue = Venue.find(params[:id])
      @queue_entries_by_status = {
        waiting: @venue.queue_entries.waiting.order(:created_at),
        notified: @venue.queue_entries.notified.order(:created_at),
        confirmed: @venue.queue_entries.confirmed.order(:created_at)
      }
    end

    private

    def ensure_manager!
      redirect_to root_path, alert: "Accès réservé aux managers" unless current_user.is_manager?
    end
  end
end
