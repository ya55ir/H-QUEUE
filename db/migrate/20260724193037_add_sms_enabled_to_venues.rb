class AddSmsEnabledToVenues < ActiveRecord::Migration[7.1]
  def change
    add_column :venues, :sms_enabled, :boolean, default: false, null: false
  end
end
