module Manager
  class VenuesController < Manager::ApplicationController
    def index
      @venues = Venue.all
    end

    def show
      @venue = Venue.find(params[:id])
      @queue_entries_by_status = {
        waiting: @venue.queue_entries.active.waiting.order(:created_at),
        notified: @venue.queue_entries.active.notified.order(:created_at),
        confirmed: @venue.queue_entries.active.confirmed.order(:created_at)
      }
    end

    def archives
      @venue = Venue.find(params[:id])
      @entries_by_day = @venue.queue_entries.archived
                               .order(archived_at: :desc)
                               .group_by { |entry| entry.archived_at.to_date }
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
