json.extract! album, :id, :name
json.artist album.artist.name
json.picture album.picture.attached? ? rails_representation_url(album.picture.variant(combine_options: { auto_orient: true })) : ''
