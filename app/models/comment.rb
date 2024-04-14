# typed: strict
# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :feature

  validates :body, presence: true, length: { maximum: 255 }
end
