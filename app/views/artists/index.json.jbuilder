# frozen_string_literal: true

json.array! @artists, partial: 'artists/artist', as: :artist
