class CreateFlashcards < ActiveRecord::Migration[8.0]
  def change
    create_table :flashcards do |t|
      t.text :front, null: false
      t.text :back, null: false
      t.references :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
