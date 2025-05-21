require 'faker'

FactoryGirl.define do
  factory :loaned_item do
    title Faker::Commerce.product_name # Changed from Book.title to something more generic
    friend_name Faker::Name.name
    loan_date Date.today
    returned false
    returned_date nil
  end
end