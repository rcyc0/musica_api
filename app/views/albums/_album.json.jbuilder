json.extract! album, :id, :name
json.artist album.artist.name
json.picture album.music.first.nil? ? '' : rails_representation_url(album.music.first.picture.variant(combine_options: { auto_orient: true }))
