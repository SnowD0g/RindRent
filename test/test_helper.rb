ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'factory_girl_rails'
require 'faker'
require 'rails/test_help'
require 'database_cleaner'

DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end
  # Add more helper methods to be used by all tests here...
end
