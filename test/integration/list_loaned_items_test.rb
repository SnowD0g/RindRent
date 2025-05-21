require 'test_helper'

class ListLoanedItemsTest < ActionDispatch::IntegrationTest
  def setup
    DatabaseCleaner.clean
    5.times {FactoryGirl.create(:loaned_item)}
  end

  test 'List all loaned_items' do
    get '/api/loaned_items'
    json_response = json(response.body) # Renamed for clarity
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json data format'
    assert_equal 200, response.status, 'Should respond with correct status code'
    refute_empty response.body, 'Should contain a response body'
    assert_equal LoanedItem.all.size, json_response[:data].size, 'Should include all the loaned_items'
    assert_serializer 'ActiveModel::Serializer::CollectionSerializer', 'Should serialize response with the right Serializer'
    # Check for new attributes in the first item of the collection
    if json_response[:data].any?
      first_item_attributes = json_response[:data][0][:attributes]
      assert first_item_attributes.key?(:title), "Response should include title"
      assert first_item_attributes.key?(:friend_name), "Response should include friend_name"
      assert first_item_attributes.key?(:loan_date), "Response should include loan_date"
      assert first_item_attributes.key?(:returned), "Response should include returned status"
    end
  end

  test 'list a specific loaned_item by id' do
    loaned_item = FactoryGirl.create(:loaned_item)

    get "/api/loaned_items/#{loaned_item.id}"

    json_response = json(response.body) # Renamed for clarity
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json data format'
    assert_equal 200, response.status,'Should respond with correct status code'
    refute_empty response.body, 'Should contain a response body'
    assert_equal loaned_item.id, json_response[:data][:id].to_i, 'Response should include the right loaned_item'
    # Check for new attributes
    item_attributes = json_response[:data][:attributes]
    assert_equal loaned_item.title, item_attributes[:title]
    assert_equal loaned_item.friend_name, item_attributes[:friend_name]
    assert_equal loaned_item.loan_date.to_s, item_attributes[:loan_date] # Compare as string due to JSON conversion
    assert_equal loaned_item.returned, item_attributes[:returned]
  end

  test 'list a specific loaned_item with invalid id' do
    get '/api/loaned_items/asd'

    json = json(response.body)
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json data format'
    assert_equal 404, response.status,'Should respond with correct status code'
    refute_empty response.body, 'Should contain a response body'
    assert  json[:data][:message].present?, 'Response should include an error message'
  end
end
