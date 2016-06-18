class BookSerializer < ActiveModel::Serializer
  #cache key: 'book', expires_in: 2.hours senza memcache non è performante !
  attributes :id, :title, :description, :isbn, :note, :created_at, :updated_at, :cover_url

  def cover_url
    object.cover.url
  end
end
