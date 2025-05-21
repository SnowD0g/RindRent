require 'test_helper'

class ManageLoanedItemsTest < ActionDispatch::IntegrationTest

  test 'create a new LoanedItem' do
    # Assuming factory provides valid default friend_name and loan_date
    loaned_item_attrs = FactoryGirl.attributes_for(:loaned_item)
    # The api_create_loaned_item helper would typically take these attributes
    # For now, let's assume it posts: loaned_item: loaned_item_attrs
    # If api_create_loaned_item takes an object, then:
    # loaned_item_obj = FactoryGirl.build(:loaned_item)
    # api_create_loaned_item(loaned_item_obj)

    # Simulate direct post if api_create_loaned_item is not available/clear
    post "/api/loaned_items",
         params: { loaned_item: loaned_item_attrs }.to_json,
         headers: { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }


    json_response = json(response.body)
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json format data'
    assert_equal 201, response.status, 'Should return the right status code'
    refute_empty response.body, 'Should render a request body'
    assert_equal api_loaned_item_url(json_response[:data][:id]), response.location, 'Should include the resource\'s correct location'

    # Verify new attributes in response
    created_attributes = json_response[:data][:attributes]
    assert_equal loaned_item_attrs[:title], created_attributes[:title]
    assert_equal loaned_item_attrs[:friend_name], created_attributes[:friend_name]
    assert_equal loaned_item_attrs[:loan_date].to_s, created_attributes[:loan_date]
    assert_equal false, created_attributes[:returned] # Default value
  end

  test 'submit an invalid loaned_item (e.g. missing title)' do
    # api_create_loaned_item(loaned_item)
    # Simulate direct post if api_create_loaned_item is not available/clear
    invalid_attrs = FactoryGirl.attributes_for(:loaned_item, title: nil)
    post "/api/loaned_items",
         params: { loaned_item: invalid_attrs }.to_json,
         headers: { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    # Check errors (assuming LoanedItem model has `validates :title, presence: true`)
    # loaned_item_obj_for_errors = LoanedItem.new(invalid_attrs) # Helper to get expected errors
    # loaned_item_obj_for_errors.valid? # Populate errors

    json_response = json(response.body)
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json format data'
    assert_equal 422, response.status, 'Should return the right status code'
    refute_empty response.body, 'Should render a request body'
    # assert_equal loaned_item_obj_for_errors.errors.full_messages, json_response[:data][:message]
    assert json_response[:data][:message].include?("Title can't be blank"), "Error message should include title can't be blank"
  end

  test 'submit an invalid loaned_item (e.g. missing friend_name)' do
    invalid_attrs = FactoryGirl.attributes_for(:loaned_item, friend_name: nil)
    post "/api/loaned_items",
         params: { loaned_item: invalid_attrs }.to_json,
         headers: { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    json_response = json(response.body)
    assert_equal 422, response.status
    assert json_response[:data][:message].include?("Friend name can't be blank")
  end


  test 'submit an invalid loaned_item (e.g. missing loan_date)' do
    invalid_attrs = FactoryGirl.attributes_for(:loaned_item, loan_date: nil)
    post "/api/loaned_items",
         params: { loaned_item: invalid_attrs }.to_json,
         headers: { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    json_response = json(response.body)
    assert_equal 422, response.status
    assert json_response[:data][:message].include?("Loan date can't be blank")
  end

  test 'successful update a loaned_item' do
    loaned_item = FactoryGirl.create(:loaned_item)
    updated_attrs = {
      title: 'Updated Title',
      friend_name: 'Updated Friend',
      returned: true,
      returned_date: Date.today
    }
    patch "/api/loaned_items/#{loaned_item.id}",
    params: { loaned_item: updated_attrs }.to_json,
    headers: { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }

    json_response = json(response.body)
    assert_equal 200, response.status, 'Should return the right status code'
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json format data'
    refute_empty response.body, 'Should render a request body'

    reloaded_item = loaned_item.reload
    assert_equal updated_attrs[:title], reloaded_item.title
    assert_equal updated_attrs[:friend_name], reloaded_item.friend_name
    assert_equal updated_attrs[:returned], reloaded_item.returned
    assert_equal updated_attrs[:returned_date], reloaded_item.returned_date

    response_attributes = json_response[:data][:attributes]
    assert_equal updated_attrs[:title], response_attributes[:title]
    assert_equal updated_attrs[:friend_name], response_attributes[:friend_name]
    assert_equal updated_attrs[:returned], response_attributes[:returned]
    assert_equal updated_attrs[:returned_date].to_s, response_attributes[:returned_date]
  end

  test 'update a loaned_item with invalid data (e.g. title: nil)' do
    loaned_item = FactoryGirl.create(:loaned_item)
    patch "/api/loaned_items/#{loaned_item.id}",
    params: { loaned_item: { title: nil } }.to_json,
    { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    json = json(response.body)

    assert_equal 422, response.status, 'Should return the right status code'
    assert_equal Mime::JSON, response.content_type, 'Should respond in Json format data'
    refute_empty response.body, 'Should render a request body'
    assert json[:data][:message].present?, 'Should render error messages'
  end

  test 'delete existing loaned_item' do
    loaned_item = FactoryGirl.create(:loaned_item)
    loaned_items_size = LoanedItem.count
    delete "/api/loaned_items/#{loaned_item.id}"
    assert_equal 204, response.status, 'Should return the right status code'
    assert_empty response.body, 'Should render an empty response body'
    refute_equal loaned_items_size, LoanedItem.count,'Should remove the element from the database'
  end

  test 'mark an item as returned via UI-like patch request' do
    loaned_item = FactoryGirl.create(:loaned_item, returned: false, returned_date: nil)

    assert_not loaned_item.returned?, "Item should initially be not returned"

    # This simulates the PATCH request that the "Mark as Returned" button would trigger
    patch mark_as_returned_loaned_item_path(loaned_item)

    assert_redirected_to loaned_items_path
    assert_equal 'Loaned item was successfully marked as returned.', flash[:notice]

    loaned_item.reload
    assert loaned_item.returned?, "Item should be marked as returned in the database"
    assert_equal Date.current, loaned_item.returned_date, "Returned date should be set to current date in the database"

    # Optional: Follow redirect and check if the button is gone or text changed on index page
    # get loaned_items_path
    # assert_select "a[href=?]", mark_as_returned_loaned_item_path(loaned_item), count: 0 # Check button is no longer there
    # Or check for "Yes (date)" text if your view was updated that way
  end
end
