class Album < ApplicationRecord
  belongs_to :artist
  has_many :music, dependent: :restrict_with_error
end
