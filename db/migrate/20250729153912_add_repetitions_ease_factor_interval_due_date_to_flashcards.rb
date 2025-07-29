class AddRepetitionsEaseFactorIntervalDueDateToFlashcards < ActiveRecord::Migration[8.0]
  def change
    add_column :flashcards, :repetitions, :integer, default: 0
    add_column :flashcards, :ease_factor, :float, default: 2.5
    add_column :flashcards, :interval, :integer, default: 0
    add_column :flashcards, :due_date, :date
  end
end
