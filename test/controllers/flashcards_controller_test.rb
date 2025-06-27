require "test_helper"

class FlashcardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @flashcard = flashcards(:one)
  end

  test "should get index" do
    get flashcards_url, as: :json
    assert_response :success
  end

  test "should create flashcard" do
    assert_difference("Flashcard.count") do
      post flashcards_url, params: { flashcard: { back: @flashcard.back, deck_id: @flashcard.deck_id, front: @flashcard.front } }, as: :json
    end

    assert_response :created
  end

  test "should show flashcard" do
    get flashcard_url(@flashcard), as: :json
    assert_response :success
  end

  test "should update flashcard" do
    patch flashcard_url(@flashcard), params: { flashcard: { back: @flashcard.back, deck_id: @flashcard.deck_id, front: @flashcard.front } }, as: :json
    assert_response :success
  end

  test "should destroy flashcard" do
    assert_difference("Flashcard.count", -1) do
      delete flashcard_url(@flashcard), as: :json
    end

    assert_response :no_content
  end
end
