class DecksController < ApplicationController
  before_action :set_deck, :authorize_user, only: %i[ show update destroy ]

  # GET /decks
  def index
    render json: current_user.decks.where(deleted: false).order(created_at: :desc), include: { flashcards: { methods: [ :front_image_url, :back_image_url, :due_today ] } }
  end

  # GET /decks/1
  def show
    render json: @deck, include: { flashcards: { methods: [ :front_image_url, :back_image_url ] } }
  end

  # POST /decks
  def create
    @deck = current_user.decks.create(deck_params)

    if @deck.save
      render json: @deck, include: { flashcards: { methods: [ :front_image_url, :back_image_url ] } }, status: :created, location: @deck
    else
      render json: @deck.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /decks/1
  def update
    if @deck.update(deck_params)
      render json: @deck, include: { flashcards: { methods: [ :front_image_url, :back_image_url ] } }
    else
      render json: @deck.errors, status: :unprocessable_entity
    end
  end

  # DELETE /decks/1
  def destroy
    @deck.update_attribute!(:deleted, true)
  end

  private
    def set_deck
      @deck = Deck.includes(:flashcards).find(params.expect(:id))
    end

    def authorize_user
      render status: :unauthorized if @deck.user != current_user
    end

    def deck_params
      params.expect(deck: [ :name, :place, flashcards_attributes: [ [ :front, :back, :front_image, :back_image ] ] ])
    end
end
