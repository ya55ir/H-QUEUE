class ApplicationController < ActionController::Base
  before_action :redirect_to_www
  before_action :authenticate_user!

  private

  def redirect_to_www
    return unless request.host == "hqueue.app"

    redirect_to "https://www.hqueue.app#{request.fullpath}", status: :moved_permanently
  end
end
