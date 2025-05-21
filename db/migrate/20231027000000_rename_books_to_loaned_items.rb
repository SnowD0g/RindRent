class RenameBooksToLoanedItems < ActiveRecord::Migration[5.0]
  def change
    rename_table :books, :loaned_items
  end
end
