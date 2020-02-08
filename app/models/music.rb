require_relative Rails.root.join 'lib/music_info'

class Music < ApplicationRecord
  belongs_to :album, optional: true
  belongs_to :artist, optional: true
  belongs_to :genre, optional: true
  has_one_attached :file
  has_one_attached :thumbnail
  has_one_attached :picture

  before_create do
    self.album_id = Album.first.id
    self.artist_id = Artist.first.id
    self.genre_id = Genre.first.id
  end
end
