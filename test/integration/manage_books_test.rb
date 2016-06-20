require 'test_helper'

class ManageBooksTest < ActionDispatch::IntegrationTest

  test 'create a new Book' do
    book = FactoryGirl.build(:book)
    api_create_book(book)

    json_response = json(response.body)
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json format data'
    assert_equal 201, response.status, 'Should return the right status code'
    refute_empty response.body, 'Should render a request body'
    assert_equal api_book_url(json_response[:data][:id]), response.location, 'Should inclure the resource\'s currect location'
  end

  test 'submit an invalid book' do
    book = FactoryGirl.build(:book, title: nil)
    api_create_book(book)
    book.valid?
    json = json(response.body)
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json format data'
    assert_equal 422, response.status, 'Should return the right status code'
    refute_empty response.body, 'Should render a request body'
    assert_equal book.errors.full_messages, json[:data][:message]
  end

  test 'successful update a book' do
    book = FactoryGirl.create(:book)
    patch "/api/books/#{book.id}",
    { book: { title: 'Update Test Sa sa sa' } }.to_json,
    { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    json = json(response.body)

    assert_equal 200, response.status, 'Should return the right status code'
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json format data'
    refute_empty response.body, 'Should render a request body'
    assert_equal 'Update Test Sa sa sa', book.reload.title, 'Should Update the attribute value'
    assert_equal 'Update Test Sa sa sa', json[:data][:attributes][:title], 'Should Return an updated Json rappresentation of the Object'

  end

  test 'update a book with wrong id' do
    book = FactoryGirl.create(:book)
    patch "/api/books/#{book.id}",
    { book: { title: nil } }.to_json,
    { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    json = json(response.body)

    assert_equal 422, response.status, 'Should return the right status code'
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json format data'
    refute_empty response.body, 'Should render a request body'
    assert json[:data][:message].present?, 'Should render error messages'
  end

  test 'delete existing episode' do
    book = FactoryGirl.create(:book)
    books_size = Book.count
    delete "/api/books/#{book.id}"
    assert_equal 204, response.status, 'Should return the right status code'
    assert_empty response.body, 'Should render an empty response body'
    refute_equal books_size, Book.count,'Should remove the element from the database'
  end
end
