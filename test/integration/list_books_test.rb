require 'test_helper'

class ListBooksTest < ActionDispatch::IntegrationTest
  def setup
    DatabaseCleaner.clean
    5.times {FactoryGirl.create(:book)}
  end

  test 'List all books' do
    get '/api/books'
    json = json(response.body)
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json data format'
    assert_equal 200, response.status, 'Should respond with correct status code'
    refute_empty response.body, 'Should contain a response body'
    assert_equal Book.all.size, json[:data].size, 'Should include all the books'
    assert_serializer 'ActiveModel::Serializer::CollectionSerializer', 'Should serialize response with the right Serializer'
  end

  test 'list a specific book by id' do
    book = FactoryGirl.create(:book)

    get "/api/books/#{book.id}"

    json = json(response.body)
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json data format'
    assert_equal 200, response.status,'Should respond with correct status code'
    refute_empty response.body, 'Should contain a response body'
    assert_equal book.id, json[:data][:id].to_i, 'Response should include the right book'
  end

  test 'list a specific book with invalid id' do
    get '/api/books/asd'

    json = json(response.body)
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json data format'
    assert_equal 404, response.status,'Should respond with correct status code'
    refute_empty response.body, 'Should contain a response body'
    assert  json[:data][:message].present?, 'Response should include an error message'
  end
end
