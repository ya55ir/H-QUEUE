class CreateVenues < ActiveRecord::Migration[8.1]
  def change
    create_table :venues do |t|
      t.string :venue_type
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.text :description
      t.text :opening_hours
      t.integer :avg_wait_minutes
      t.string :photo_url

      t.timestamps
    end
  end
end
