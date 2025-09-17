class Deck < ApplicationRecord
  belongs_to :user
  has_many :flashcards, dependent: :destroy
  accepts_nested_attributes_for :flashcards

  def as_json(options = {})
    super(
      only: [ :id, :name ],
      include: {
        flashcards: {
          methods: [ :front_image_url, :back_image_url, :due_today ]
        }
      }
    )
  end
end
