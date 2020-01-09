class Album < ApplicationRecord
  belongs_to :artist
  has_many :music
end
