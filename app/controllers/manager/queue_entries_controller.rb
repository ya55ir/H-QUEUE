module Manager
  class QueueEntriesController < Manager::ApplicationController
    before_action :set_queue_entry

    def notify
      @queue_entry.update(status: :notified, notified_at: Time.current)
      redirect_to manager_venue_path(@queue_entry.venue)
    end

    private

    def set_queue_entry
      @queue_entry = QueueEntry.find(params[:id])
    end
  end
end
