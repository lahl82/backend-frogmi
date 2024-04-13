# typed: strict
# frozen_string_literal: true

class CreateFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :features do |t|
      t.string :place, null: false
      t.string :mag_type, null: false
      t.string :title, null: false
      t.decimal :longitude, null: false
      t.decimal :latitude, null: false
      t.string :external_url, null: false
      t.decimal :magnitude, null: false
      t.string :external_id, null: false
      t.string :time
      t.boolean :tsunami
    end

    add_index :features, :external_id, unique: true
  end
end
