class User < ApplicationRecord
  include Rodauth::Rails.model

  enum :status, { unverified: 1, verified: 2, closed: 3 }

  has_many :decks, dependent: :destroy
  has_many :study_sessions, dependent: :destroy
  has_one :todays_progress, dependent: :destroy
end
