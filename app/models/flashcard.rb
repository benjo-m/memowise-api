class Flashcard < ApplicationRecord
  belongs_to :deck
  has_one_attached :front_image
  has_one_attached :back_image

  def front_image_url
    Rails.application.routes.url_helpers.rails_blob_path(front_image, only_path: true) if front_image.attached?
  end

  def back_image_url
    Rails.application.routes.url_helpers.rails_blob_path(back_image, only_path: true) if back_image.attached?
  end
end
