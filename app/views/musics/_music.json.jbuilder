# frozen_string_literal: true

json.extract! music, :id, :analyzed_status
json.filename music.file.filename
json.artist music.artist.name
json.album music.album.name
json.track music.track unless music.track.nil?
json.title music.title unless music.title.nil?
json.comment music.comment unless music.comment.nil?
json.comment music.year unless music.year.nil?
json.url music_url(music, format: :json)
json.file_url rails_blob_url(music.file) if music.file.attached?
json.picture_url rails_representation_url(music.picture.variant(combine_options: { auto_orient: true })) if music.picture.attached?
