module Manager
  class VenuesController < Manager::ApplicationController
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
      @next_entry = @queue_entries_by_status[:waiting].first
    end
  end
end
