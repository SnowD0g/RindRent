require 'test_helper'

# noinspection RubyArgCount
class BookTest < ActiveSupport::TestCase

  # noinspection RubyArgCount
  def setup
    @book = FactoryGirl.build(:book)
  end

  should validate_presence_of(:title)
  should validate_presence_of(:isbn)
  should allow_value('9788175257665').for(:isbn)
  should allow_value('1234567890').for(:isbn)
  should allow_value('123456789X').for(:isbn)
  should allow_value('97-8-81-75-257-665').for(:isbn)

  should_not allow_value('').for(:isbn)
  should_not allow_value('1').for(:isbn)
  should_not allow_value('978817525766').for(:isbn)
  should_not allow_value('978817525766875').for(:isbn)


  test 'default cover if none is assigned' do
    @book.cover = nil
    assert_match /default/, @book.cover.url,  'Should have a default cover'
  end

  test 'cover cant have invalid filetype ' do
    @book.cover = File.open('test/assets/sample.pdf')
    assert_not @book.valid?, 'Should be invalid with an unpermitted attachment type'
  end
end
