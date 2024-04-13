# typed: strict
# frozen_string_literal: true

class Feature < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :external_id, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :external_url, presence: true, length: { maximum: 1000 }
  validates :place, presence: true, length: { maximum: 1000 }
  validates :mag_type, presence: true, length: { maximum: 3 }
  validates :latitude, presence: true, inclusion: { in: -90..90 }
  validates :longitude, presence: true, inclusion: { in: -180..180 }
  validates :magnitude, presence: true, inclusion: { in: -1..10 }
end
