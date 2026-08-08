class ArchiveDailyQueueJob < ApplicationJob
  queue_as :default

  def perform
    QueueEntry.archive_daily!
  end
end
