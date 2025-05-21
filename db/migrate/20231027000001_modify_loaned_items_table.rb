class ModifyLoanedItemsTable < ActiveRecord::Migration[5.0]
  def change
    # Remove old columns
    remove_column :loaned_items, :description, :text
    remove_column :loaned_items, :isbn, :string
    remove_column :loaned_items, :note, :text
    remove_column :loaned_items, :cover, :string

    # Add new columns
    add_column :loaned_items, :friend_name, :string
    add_column :loaned_items, :loan_date, :date
    add_column :loaned_items, :returned_date, :date, null: true
    add_column :loaned_items, :returned, :boolean, default: false, null: false
  end
end
