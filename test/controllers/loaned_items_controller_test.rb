require 'test_helper'

class LoanedItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loaned_item = FactoryGirl.create(:loaned_item, returned: false, returned_date: nil)
  end

  test "should mark loaned item as returned" do
    assert_not @loaned_item.returned?, "Item should initially be not returned"

    patch mark_as_returned_loaned_item_url(@loaned_item)

    @loaned_item.reload
    assert @loaned_item.returned?, "Item should be marked as returned"
    assert_equal Date.current, @loaned_item.returned_date, "Returned date should be set to current date"
    assert_redirected_to loaned_items_url
    assert_equal 'Loaned item was successfully marked as returned.', flash[:notice]
  end

  test "should not mark returned if update fails" do
    # Simulate a failure during update
    LoanedItem.any_instance.stubs(:update).returns(false)

    patch mark_as_returned_loaned_item_url(@loaned_item)

    @loaned_item.reload
    assert_not @loaned_item.returned?, "Item should still be not returned if update fails"
    assert_nil @loaned_item.returned_date, "Returned date should not be set if update fails"
    assert_redirected_to loaned_items_url
    assert_equal 'Could not mark item as returned.', flash[:alert]
  end
end
