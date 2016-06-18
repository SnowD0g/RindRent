require 'test_helper'

class ListBooksTest < ActionDispatch::IntegrationTest
  test 'List all books' do
    FactoryGirl.create(:book)
    FactoryGirl.create(:book)
    FactoryGirl.create(:book)

    get '/api/books'
    books = JSON.parse(response.body)
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json data format'
    assert_equal 200, response.status, 'Should respond in Json data format'
    refute_empty response.body, 'Should contain a response body'
    assert_equal Book.all.size, books.size
  end
end
