class Deck < ApplicationRecord
  belongs_to :user
  has_many :flashcards, dependent: :destroy
  accepts_nested_attributes_for :flashcards
end
