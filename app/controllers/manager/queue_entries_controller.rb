module Manager
  class QueueEntriesController < Manager::ApplicationController
    before_action :set_queue_entry

    def notify
      @queue_entry.update(status: :notified, notified_at: Time.current)
      send_notify_sms if @queue_entry.venue.sms_enabled?
      redirect_to manager_venue_path(@queue_entry.venue)
    end

    private

    def set_queue_entry
      @queue_entry = QueueEntry.find(params[:id])
    end

    def send_notify_sms
      venue = @queue_entry.venue
      confirmation_link = confirmation_queue_entry_url(@queue_entry)

      TwilioSmsService.call(
        to: @queue_entry.display_phone,
        body: "#{venue.name}: your table is ready! Confirm your arrival: #{confirmation_link}"
      )
    rescue Twilio::REST::TwilioError => e
      Rails.logger.error("Twilio SMS failed for QueueEntry##{@queue_entry.id}: #{e.message}")
    end
  end
end
