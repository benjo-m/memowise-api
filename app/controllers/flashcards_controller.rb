class FlashcardsController < ApplicationController
  before_action :set_flashcard, only: %i[ show update destroy ]

  # GET /flashcards
  def index
    @flashcards = Flashcard.all

    render json: @flashcards
  end

  # GET /flashcards/1
  def show
    render json: @flashcard, methods: [ :front_image_url, :back_image_url ]
  end

  # POST /flashcards
  def create
    @flashcard = Flashcard.new(flashcard_params)

    if @flashcard.save
      render json: @flashcard, methods: [ :front_image_url, :back_image_url ], status: :created, location: @flashcard
    else
      render json: @flashcard.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /flashcards/1
  def update
    if @flashcard.update(flashcard_params)
      render json: @flashcard
    else
      render json: @flashcard.errors, status: :unprocessable_entity
    end
  end

  # DELETE /flashcards/1
  def destroy
    @flashcard.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flashcard
      @flashcard = Flashcard.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def flashcard_params
      params.expect(flashcard: [ :front, :back, :deck_id, :front_image, :back_image ])
    end
end
