ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'factory_girl_rails'
require 'faker'
require 'rails/test_help'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
