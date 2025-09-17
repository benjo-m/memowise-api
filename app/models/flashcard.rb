class Flashcard < ApplicationRecord
  before_validation :set_default_due_date, on: :create
  belongs_to :deck
  has_one_attached(:front_image) { |attachable| attachable.variant :resized, resize_to_limit: [ 500, 500 ] }
  has_one_attached(:back_image) { |attachable| attachable.variant :resized, resize_to_limit: [ 500, 500 ] }

  def set_default_due_date
    self.due_date = Date.today
  end

  def due_today
    self.due_date <= Date.today
  end

  def front_image_url
    Rails.application.routes.url_helpers.rails_blob_path(front_image.variant(:resized), only_path: true) if front_image.attached?
  end

  def back_image_url
    Rails.application.routes.url_helpers.rails_blob_path(back_image.variant(:resized), only_path: true) if back_image.attached?
  end

  def as_json(options = {})
    super(only: [ :id, :deck_id, :front, :back ], methods: [ :front_image_url, :back_image_url, :due_today ])
  end
end
