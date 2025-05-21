require 'test_helper'

# noinspection RubyArgCount
class LoanedItemTest < ActiveSupport::TestCase

  # noinspection RubyArgCount
  def setup
    @loaned_item = FactoryGirl.build(:loaned_item)
  end

  should validate_presence_of(:title)
  should validate_presence_of(:friend_name)
  should validate_presence_of(:loan_date)

  test 'should be valid with title, friend_name, and loan_date' do
    # Factory should provide a valid item
    assert @loaned_item.valid?, "Loaned item should be valid, but got errors: #{@loaned_item.errors.full_messages.join(', ')}"
  end

  test 'returned attribute defaults to false' do
    new_item = LoanedItem.new(title: "Test Item", friend_name: "Test Friend", loan_date: Date.today)
    assert_equal false, new_item.returned, "Returned should default to false"
  end
end
