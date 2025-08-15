class ApplicationController < ActionController::API
  def current_user
    rodauth.rails_account
  end
end
