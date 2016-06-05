require 'faker'
FactoryGirl.define do
  factory :book do
    title Faker::Book.title
    description Faker::Hipster.sentence
    cover Faker::Avatar.image('my-own-slug', '50x50', 'jpg')
    isbn Faker::Code.isbn
    note Faker::Hipster.sentence
  end
end
