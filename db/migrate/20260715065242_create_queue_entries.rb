class CreateQueueEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :queue_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :venue, null: false, foreign_key: true
      t.integer :party_size
      t.integer :status
      t.datetime :notified_at

      t.timestamps
    end
  end
end
