# typed: strict
# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :feature

  NAME_REGEX = /\A([[[:alpha:]]-' ])*\z/
  PHONE_REGEX = /\A(((\(\d+\))|(\+))?([\d\-[[:space:]]]))+\z/

  validates :name, :last_name, :phone, presence: true
  validates :name, format: { with: NAME_REGEX }, length: { minimum: 2, maximum: 50 }
  validates :last_name, format: { with: NAME_REGEX }, length: { minimum: 2, maximum: 50 }
  validates :phone, format: { with: PHONE_REGEX }, length: { minimum: 11, maximum: 20 }
  validates :role, presence: true
end
