# typed: strict
# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.timestamps null: false

      t.references :feature, null: false, foreign_key: true
    end
  end
end
