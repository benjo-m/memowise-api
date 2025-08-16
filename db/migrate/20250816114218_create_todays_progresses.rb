class CreateTodaysProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :todays_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :flashcards_due_today_count, default: 0
      t.integer :flashcards_reviewed_today_count, default: 0
      t.date :progress_date

      t.timestamps
    end
  end
end
