class Artist < ApplicationRecord
  has_many :music, dependent: :restrict_with_error
  has_one_attached :picture
end
