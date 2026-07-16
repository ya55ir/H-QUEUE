class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:style_guide]

  def style_guide
    @sample_venue = Venue.first
  end
end
