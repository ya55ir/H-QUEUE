module Manager
  class ApplicationController < ::ApplicationController
    before_action :ensure_manager!

    private

    def ensure_manager!
      redirect_to root_path, alert: "Accès réservé aux managers" unless current_user.is_manager?
    end
  end
end
