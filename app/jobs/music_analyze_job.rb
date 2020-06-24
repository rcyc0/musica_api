# frozen_string_literal: true

require 'taglib'
require 'mime/types'

class MusicAnalyzeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    music_list = Music.where(analyzed_status: 1)
    music_list.each do |m|
      m.file.open do |f|
        case File.extname(f.path.to_s.downcase)
        when '.flac'
          meta_data = get_flac_info(f.path)
          picrure_content_type = meta_data['picture']['mime_type']
          unless picrure_content_type.nil?
            img_path = f.path.to_s.gsub('flac', MIME::Types[picrure_content_type].first.extensions.first)
            File.open(img_path, 'wb') do |img|
              img.puts meta_data['picture']['data']
            end
            picture_filename = m.file.filename.to_s.gsub('flac', MIME::Types[picrure_content_type].first.extensions.first)
            m.picture.attach(io: File.open(img_path),
                             filename: picture_filename,
                             content_type: picrure_content_type)
            picture = { path: img_path, filename: picture_filename, content_type: picrure_content_type }
          end
          m.title = meta_data['tag']['title']
          m.comment = meta_data['tag']['comment']
          m.track = meta_data['tag']['track']
          m.year = meta_data['tag']['year']

          m.artist = get_relation_model('artist', meta_data['tag']['artist'], picture)
          m.album = get_relation_model('album', meta_data['tag']['album'], picture, artist: m.artist)
          m.genre = get_relation_model('genre', meta_data['tag']['genre'], picture)

          m.save
        end
      end

      m.analyzed_status = 0
      m.save
    end
  end

  private

  def get_flac_info(file)
    TagLib::FLAC::File.open file do |f|
      meta_data = {}
      meta_data['picture'] = {}
      meta_data['tag'] = {}
      meta_data['picture']['data'] = f.picture_list.first.data unless f.picture_list.empty?
      meta_data['picture']['mime_type'] = f.picture_list.first.mime_type unless f.picture_list.empty?
      meta_data['tag']['title'] = f.tag.title
      meta_data['tag']['artist'] = f.tag.artist
      meta_data['tag']['comment'] = f.tag.comment
      meta_data['tag']['genre'] = f.tag.genre
      meta_data['tag']['album'] = f.tag.album
      meta_data['tag']['track'] = f.tag.track
      meta_data['tag']['year'] = f.tag.year
      return meta_data
    end
  end

  def get_relation_model(model_name, name, picture, relation_model = nil)
    model = eval(model_name.capitalize)
    m = model.find_by(name: name)
    if m.nil?
      m = if relation_model.nil?
            model.new(name: name)
          else
            model.new(name: name, relation_model.keys.first => relation_model[relation_model.keys.first])
          end
      m.save
      m = model.find_by(name: name)
    end
    unless m.picture.attached? ^ picture.nil?
      m.picture.attach(io: File.open(picture[:path]),
                       filename: picture[:filename],
                       content_type: picture[:content_type])
    end
    m
  end
end
