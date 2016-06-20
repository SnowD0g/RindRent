ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'factory_girl_rails'
require 'faker'
require 'rails/test_help'
require 'database_cleaner'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  include ActiveModelSerializers::Test::Serializer

  DatabaseCleaner.strategy = :truncation

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end

  def json(body)
    JSON.parse(body, symbolize_names: true)
  end

  def api_create_book(book)
    post '/api/books',
     { book: {title: book.title, isbn: book.isbn, description: book.description, note: book.note}}.to_json,
     { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
  end
end
