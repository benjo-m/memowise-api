class UsersController < ApplicationController
  def get_stats
    study_sessions = current_user.study_sessions

    total_sessions = study_sessions.size
    total_duration = study_sessions.sum(&:duration)
    total_correct = study_sessions.sum(&:correct_answers)
    total_incorrect = study_sessions.sum(&:incorrect_answers)
    total_flashcards = total_correct + total_incorrect

    deck_counts = study_sessions.group_by(&:deck_id).transform_values(&:size)
    most_frequent_deck_id, most_frequent_deck_count = deck_counts.max_by { |_, count| count } || [ nil, 0 ]
    favorite_deck_name = most_frequent_deck_id ? favorite_deck_name = Deck.where(id: most_frequent_deck_id).pluck(:name).first : nil

    stats = {
      longest_study_streak: longest_study_streak(study_sessions),
      current_study_streak: current_study_streak(study_sessions),
      total_study_sessions: total_sessions,
      total_time_spent_studying: total_duration,
      average_session_duration: total_sessions > 0 ? (total_duration / total_sessions) : 0,
      study_sessions_by_part_of_day: study_sessions_by_part_of_day(study_sessions),
      study_sessions_by_day: study_sessions_by_day(study_sessions),
      average_flashcards_reviewed_per_session: total_sessions > 0 ? (total_flashcards / total_sessions) : 0,
      total_correct_answers: total_correct,
      total_incorrect_answers: total_incorrect,
      favorite_deck: favorite_deck_name ? { deck: favorite_deck_name, count: most_frequent_deck_count } : nil
    }

    render json: stats
  end

  private
  def study_sessions_by_part_of_day(study_sessions)
    time_ranges = {
      morning: 6...12,
      afternoon: 12...17,
      evening: 17...21,
      night: (21...24).to_a + (0...6).to_a
    }

    parts_of_day = {
      morning: 0,
      afternoon: 0,
      evening: 0,
      night: 0
    }

    study_sessions.each do |session|
      hour = session.created_at.hour

      if time_ranges[:morning].cover?(hour)
        parts_of_day[:morning] += 1
      elsif time_ranges[:afternoon].cover?(hour)
        parts_of_day[:afternoon] += 1
      elsif time_ranges[:evening].cover?(hour)
        parts_of_day[:evening] += 1
      else
        parts_of_day[:night] += 1
      end
    end

    parts_of_day
  end

  def study_sessions_by_day(study_sessions)
    counts = Date::DAYNAMES.each_with_object({}) { |day, hash| hash[day] = 0 }

    study_sessions.each do |session|
      day = Date::DAYNAMES[session.created_at.wday]
      counts[day] += 1
    end

    counts
  end

  def current_study_streak(study_sessions)
    study_dates = study_sessions
                    .pluck(:created_at)
                    .map(&:to_date)
                    .uniq
                    .sort.reverse

    streak = 0
    today = Date.current

    study_dates.each_with_index do |date, i|
      expected_date = today - i
      break if date != expected_date

      streak += 1
    end

    streak
  end

  def longest_study_streak(study_sessions)
    study_dates = study_sessions
                    .pluck(:created_at)
                    .map(&:to_date)
                    .uniq
                    .sort

    best_streak = 0
    current_streak = 1
    previous_date = nil

    study_dates.each do |date|
      if previous_date.nil?
        current_streak = 1
      elsif date == previous_date + 1
        current_streak += 1
      else
        best_streak = [ best_streak, current_streak ].max
        current_streak = 1
      end
      previous_date = date
    end

    [ best_streak, current_streak ].max
  end
end
