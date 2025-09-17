class FlashcardsController < ApplicationController
  before_action :set_flashcard, only: %i[ update destroy ]

  def create
    @flashcard = current_user.decks.find(flashcard_params[:deck_id]).flashcards.create(flashcard_params)

    if @flashcard.save
      current_user.todays_progress.increment!(:flashcards_due_today_count)
      render json: @flashcard, status: :created, location: @flashcard
    else
      render json: @flashcard.errors, status: :unprocessable_entity
    end
  end

  def update
    @flashcard.front_image.purge if @flashcard.front_image.attached? && flashcard_params[:remove_front_image] == "true"
    @flashcard.back_image.purge if @flashcard.back_image.attached? && flashcard_params[:remove_back_image] == "true"

    if @flashcard.update(flashcard_params.except(:remove_front_image, :remove_back_image))
      render json: @flashcard
    else
      render json: @flashcard.errors, status: :unprocessable_entity
    end
  end

  def batch_update_flashcards_stats
    flashcards_to_update.each do |flashcard|
      Flashcard.find(flashcard[:id]).update(flashcard.except(:id))
    end
  end

  def destroy
    current_user.todays_progress.decrement!(:flashcards_due_today_count) if @flashcard.due_today
    @flashcard.destroy!
  end

  private
    def set_flashcard
      @flashcard = Flashcard.find(params.expect(:id))
    end

    def flashcard_params
      params.expect(flashcard: [ :front, :back, :deck_id, :front_image, :back_image, :remove_front_image, :remove_back_image ])
    end

    def flashcards_to_update
      params.expect(flashcards: [ [ :id, :repetitions, :interval, :ease_factor, :due_date ] ])
    end
end
