class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  include SessionsHelper

  private

    def logged_in_member
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url, status: :see_other
      end
    end
end
