class Deck < ApplicationRecord
  belongs_to :user
  has_many :flashcards, dependent: :destroy
end
