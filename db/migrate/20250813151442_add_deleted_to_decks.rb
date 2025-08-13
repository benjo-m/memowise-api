class AddDeletedToDecks < ActiveRecord::Migration[8.0]
  def change
    add_column :decks, :deleted, :boolean, default: false
  end
end
