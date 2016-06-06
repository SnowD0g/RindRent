require 'test_helper'

# noinspection RubyArgCount
class BookTest < ActiveSupport::TestCase

  # noinspection RubyArgCount
  def setup
    @book = FactoryGirl.build(:book)
  end

  test 'invalid without title' do
     @book.title = nil
    assert_not @book.valid?, 'Should be invalid without a title'
  end

  test 'invalid without isbn' do
    @book.isbn= nil
    assert_not @book.valid?, 'Should be invalid without an isbn code'
  end

  test 'invalid with wrong isbn code' do
    @book.isbn= 'Invalid ISBN'
    assert_not @book.valid?, 'Should be invalid with invalid isbn code'
  end

  test 'default cover if none is assigned' do
    @book.cover = nil
    assert_match /default/, @book.cover.url,  'Should have a default cover'
  end

  test 'cover cant have invalid filetype ' do
    @book.cover = File.open('test/assets/sample.pdf')
    assert_not @book.valid?, 'Should be invalid with an unpermitted attachment type'
  end
end
