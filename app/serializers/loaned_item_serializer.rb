class LoanedItemSerializer < ActiveModel::Serializer
  #cache key: 'loaned_item', expires_in: 2.hours senza memcache non è performante !
  attributes :id, :title, :friend_name, :loan_date, :returned, :returned_date, :created_at, :updated_at
end
