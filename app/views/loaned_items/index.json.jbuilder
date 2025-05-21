json.array!(@loaned_items) do |loaned_item|
  json.extract! loaned_item, :id, :title, :friend_name, :loan_date, :returned, :returned_date
  json.url loaned_item_url(loaned_item, format: :json)
end
