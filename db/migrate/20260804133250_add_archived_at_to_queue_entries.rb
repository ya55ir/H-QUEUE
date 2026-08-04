class AddArchivedAtToQueueEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :queue_entries, :archived_at, :datetime
    add_index :queue_entries, :archived_at
  end
end
