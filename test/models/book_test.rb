require 'test_helper'

class BookTest < ActiveSupport::TestCase
  test 'invalid without title' do
    book = build(:book, title: nil)
    assert_not book.valid?, 'Should be invalid without a title'
  end
end
