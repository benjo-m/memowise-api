class StudySessionsController < ApplicationController
  before_action :set_user

  def create
    study_session = @user.study_sessions.create(study_session_params)
    if study_session.save
      render json: study_session, status: :created
    else
      render json: study_session.errors, status: :unprocessable_entity
    end
  end

  private
  def study_session_params
    params.expect(study_session: [ :deck_id, :duration, :correct_answers, :incorrect_answers ])
  end

  def set_user
    @user = User.find(rodauth.session[:account_id])
  end
end
