class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:style_guide]

  def style_guide
    @sample_venue = Venue.first
    @sample_venue_without_photo = Venue.new(name: "Le Wagon Bleu", venue_type: "French", avg_wait_minutes: 10)
  end
end
