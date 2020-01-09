json.extract! artist, :id, :name
json.url artist_url(artist, format: :json)
json.picture  artist.music.first.nil? ? "" : rails_representation_url(artist.music.first.picture.variant(combine_options: {auto_orient: true}))