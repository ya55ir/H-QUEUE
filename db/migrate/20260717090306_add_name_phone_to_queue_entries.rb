class AddNamePhoneToQueueEntries < ActiveRecord::Migration[8.1]
  def change
    add_column :queue_entries, :name, :string
    add_column :queue_entries, :phone_number, :string
    change_column_null :queue_entries, :user_id, true
  end
end
