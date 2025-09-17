class StudySessionsController < ApplicationController
  def create
    study_session = current_user.study_sessions.create(study_session_params)

    if study_session.save
      count = current_user.todays_progress.flashcards_reviewed_today_count
      current_user.todays_progress.update(flashcards_reviewed_today_count: count + study_session.correct_answers)
      render json: study_session, status: :created
    else
      render json: study_session.errors, status: :unprocessable_entity
    end
  end

  private
  def study_session_params
    params.expect(study_session: [ :deck_id, :duration, :correct_answers, :incorrect_answers ])
  end
end
