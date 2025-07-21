class DecksController < ApplicationController
  before_action :set_user
  before_action :set_deck, :authorize_user, only: %i[ show update destroy ]

  # GET /decks
  def index
    render json: @user.decks.order(created_at: :desc)
  end

  # GET /decks/1
  def show
    render json: @deck
  end

  # POST /decks
  def create
    @deck = @user.decks.create(deck_params)

    if @deck.save
      render json: @deck, status: :created, location: @deck
    else
      render json: @deck.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /decks/1
  def update
    if @deck.update(deck_params)
      render json: @deck
    else
      render json: @deck.errors, status: :unprocessable_entity
    end
  end

  # DELETE /decks/1
  def destroy
    @deck.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deck
      @deck = Deck.find(params.expect(:id))
    end

    def set_user
      @user = User.find(rodauth.session[:account_id])
    end

    def authorize_user
      render status: :unauthorized if @deck.user != @user
    end

    # Only allow a list of trusted parameters through.
    def deck_params
      params.expect(deck: [ :name ])
    end
end
