class DecksController < ApplicationController
  before_action :set_deck, only: %i[ update destroy ]

  def index
    decks = current_user.decks.where(deleted: false).order(created_at: :desc)
    set_flashcards_due_today_count(decks) if current_user.todays_progress.progress_date < Date.today
    render json: decks
  end

  def create
    @deck = current_user.decks.create(deck_params)

    if @deck.save
      render json: @deck, status: :created, location: @deck
    else
      render json: @deck.errors, status: :unprocessable_entity
    end
  end

  def update
    if @deck.update(deck_params)
      render json: @deck
    else
      render json: @deck.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @deck.update_attribute!(:deleted, true)
    subtract_from_flashcards_due_today_count(@deck)
    render json: @deck
  end

  private
    def set_deck
      @deck = current_user.decks.find(params[:id])
    end

    def deck_params
      params.expect(deck: [ :name, :place, flashcards_attributes: [ [ :front, :back, :front_image, :back_image ] ] ])
    end

    def set_flashcards_due_today_count(decks)
      count = 0
      decks.each { |d| d.flashcards.each { |fc| count += 1 if fc.due_today } }
      current_user.todays_progress.update(flashcards_due_today_count: count, flashcards_reviewed_today_count: 0, progress_date: Date.today)
    end

    def subtract_from_flashcards_due_today_count(deck)
      to_subtract = deck.flashcards.count { |fc| fc.due_today }
      current_user.todays_progress.decrement!(:flashcards_due_today_count, to_subtract)
    end
end
