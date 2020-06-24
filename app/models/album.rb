# frozen_string_literal: true

class Album < ApplicationRecord
  belongs_to :artist
  has_many :music, dependent: :restrict_with_error
  has_one_attached :picture
end
