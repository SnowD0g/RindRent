require 'faker'

FactoryGirl.define do
  factory :book do
    title Faker::Book.title
    description Faker::Hipster.sentence
    cover Faker::Avatar.image('my-own-slug', '50x50', 'jpg')
    sequence(:isbn) {|i| "97881#{i}5257665".slice(0,13)}
    note Faker::Hipster.sentence
  end
end