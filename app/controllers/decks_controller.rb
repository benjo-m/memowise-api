class DecksController < ApplicationController
  before_action :set_deck, :authorize_user, only: %i[ show update destroy ]

  # GET /decks
  def index
    decks = current_user.decks.where(deleted: false).order(created_at: :desc)

    if current_user.todays_progress.progress_date < Date.today
      count = 0
      decks.each { |d| d.flashcards.each { |fc| count += 1 if fc.due_today } }
      current_user.todays_progress.update(flashcards_due_today_count: count, flashcards_reviewed_today_count: 0, progress_date: Date.today)
    end

    render json: decks, include: { flashcards: { methods: [ :front_image_url, :back_image_url, :due_today ] } }
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
    to_subtract = @deck.flashcards.count { |fc| fc.due_today }
    current_count = current_user.todays_progress.flashcards_due_today_count
    current_user.todays_progress.update(flashcards_due_today_count: current_count - to_subtract)
    render json: @deck, include: { flashcards: { methods: [ :due_today ] } }
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
