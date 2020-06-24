# frozen_string_literal: true

json.extract! artist, :id, :name
json.url artist_url(artist, format: :json)
json.picture artist.picture.attached? ? rails_representation_url(artist.picture.variant(combine_options: { auto_orient: true })) : ''
