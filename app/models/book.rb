class Book < ActiveRecord::Base
  mount_uploader :cover, CoverUploader
  validates :title, :isbn, presence: true
  validates :isbn, format: { with:  /\A(97(8|9))?\d{9}(\d|X)\z/, message: 'Invalid isb code' }

  before_validation :sanitize_isbn

  protected

  def sanitize_isbn
    self.isbn = isbn.gsub(/\W/,'') if isbn.present?
  end
end