class Book < ActiveRecord::Base
  mount_uploader :cover, CoverUploader
  validates :title, presence: true
  #espressione regolare non funziona
  validates :isbn, presence: true, format: { with: /(97(8|9))?\d{9}(\d|X)/, message: 'Invalid isb code' }
end