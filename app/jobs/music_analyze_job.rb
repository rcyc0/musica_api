require 'taglib'
require 'mime/types'

class MusicAnalyzeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    music_list = Music.where(analyzed_status: 1)
    music_list.each do |m|
      m.file.open do |f|
        case File.extname(f.path.to_s.downcase)
        when ".flac"
          meta_data = get_flac_info(f.path)
          img_path = f.path.to_s.gsub("flac", MIME::Types['image/png'].first.extensions.first)
          File.open(img_path, "wb") do |f|
            f.puts meta_data["picture"]["data"]
          end
          m.picture.attach(io: File.open(img_path), 
            filename: m.file.filename.to_s.gsub("flac", MIME::Types['image/png'].first.extensions.first), 
            content_type: meta_data["picture"]["mime_type"])
          m.title = meta_data["tag"]["title"]
          m.comment = meta_data["tag"]["comment"]
          m.track = meta_data["tag"]["track"]
          m.year = meta_data["tag"]["year"]

          artist = Artist.find_by(name: meta_data["tag"]["artist"])
          if artist.nil?
            artist = Artist.new(name: meta_data["tag"]["artist"])
            artist.save
            artist = Artist.find_by(name: meta_data["tag"]["artist"])
          end
          m.artist = artist

          genre = Genre.find_by(name: meta_data["tag"]["genre"])
          if genre.nil?
            genre = Genre.new(name: meta_data["tag"]["genre"])
            genre.save
            genre = Genre.find_by(name: meta_data["tag"]["genre"])
          end
          m.genre = genre

          album = Album.find_by(name: meta_data["tag"]["album"])
          if album.nil?
            album = Album.new(name: meta_data["tag"]["album"], artist: artist)
            album.save
            album = Album.find_by(name: meta_data["tag"]["album"])
          end
          m.album = album

          m.save
        when ".mp3"
          get_mp3_picture f.path
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
      meta_data["picture"] = {}
      meta_data["tag"] = {}
      meta_data["picture"]["data"] = f.picture_list.first.data
      meta_data["picture"]["mime_type"] = f.picture_list.first.mime_type
      meta_data["tag"]["title"] = f.tag.title
      meta_data["tag"]["artist"] = f.tag.artist
      meta_data["tag"]["comment"] = f.tag.comment
      meta_data["tag"]["genre"] = f.tag.genre
      meta_data["tag"]["album"] = f.tag.album
      meta_data["tag"]["track"] = f.tag.track
      meta_data["tag"]["year"] = f.tag.year
      return meta_data
    end
  end
  
  def get_mp3_picture(file)
  end
end
