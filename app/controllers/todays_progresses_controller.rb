class TodaysProgressesController < ApplicationController
  def get_todays_progress
    current_user.todays_progress
  end
end
