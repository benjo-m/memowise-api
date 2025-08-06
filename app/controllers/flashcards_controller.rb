class FlashcardsController < ApplicationController
  before_action :set_flashcard, only: %i[ show update destroy ]

  def index
    @flashcards = Flashcard.all

    render json: @flashcards
  end

  def show
    render json: @flashcard, methods: [ :front_image_url, :back_image_url ]
  end

  def create
    @flashcard = Flashcard.new(flashcard_params)

    if @flashcard.save
      render json: @flashcard, methods: [ :front_image_url, :back_image_url ], status: :created, location: @flashcard
    else
      render json: @flashcard.errors, status: :unprocessable_entity
    end
  end

  def update
    @flashcard.front_image.purge if @flashcard.front_image.attached? && flashcard_params[:remove_front_image] == "true"
    @flashcard.back_image.purge if @flashcard.back_image.attached? && flashcard_params[:remove_back_image] == "true"

    if @flashcard.update(flashcard_params.except(:remove_front_image, :remove_back_image))
      render json: @flashcard, methods: [ :front_image_url, :back_image_url ]
    else
      render json: @flashcard.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @flashcard.destroy!
  end

  private
    def set_flashcard
      @flashcard = Flashcard.find(params.expect(:id))
    end

    def flashcard_params
      params.expect(flashcard: [ :front, :back, :deck_id, :front_image, :back_image, :remove_front_image, :remove_back_image ])
    end
end
