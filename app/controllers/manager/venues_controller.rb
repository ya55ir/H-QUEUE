module Manager
  class VenuesController < Manager::ApplicationController
    def index
      @venues = Venue.where(name: ["Le Bistrot d'Yves", "Le Wagon Bleu"])
    end

    def show
      @venue = Venue.find(params[:id])
      @queue_entries_by_status = {
        waiting: @venue.queue_entries.waiting.order(:created_at),
        notified: @venue.queue_entries.notified.order(:created_at),
        confirmed: @venue.queue_entries.confirmed.order(:created_at)
      }
    end

    def toggle_sms
      @venue = Venue.find(params[:id])

      @venue.update!(
        sms_enabled: params[:sms_enabled] == "1"
      )

      redirect_to manager_venue_path(@venue)
    end
  end
end
