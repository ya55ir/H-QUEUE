class AddFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :phone_number, :string
    add_column :users, :terms_opt_in, :boolean, default: false, null: false
    add_column :users, :marketing_opt_in, :boolean, default: false
    add_column :users, :is_manager, :boolean, default: false, null: false
  end
end
