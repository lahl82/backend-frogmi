# typed: strict
# frozen_string_literal: true

require 'activerecord-import/base'
require 'activerecord-import/active_record/adapters/postgresql_adapter'

module Features
  class Action
    def call
      fetch_features
      add_features
      upsert_features
    end

    private

    FEATURE_COLUMNS = %w[place mag_type title longitude latitude external_url magnitude external_id time tsunami].freeze
    KEYS_FOR_UPDATE = %i[external_id].freeze
    UPDATE_COLUMNS = %i[place mag_type title longitude latitude external_url magnitude time tsunami].freeze
    BATCH_SIZE = 100

    attr_accessor :original_features, :prepared_features

    def fetch_features
      @original_features = Request::EntryPoint.call(env_name: 'EARTHQUAKE_USGS_URL')
    end

    def add_features
      @prepared_features = prepare_features
    end

    def prepare_features
      @original_features['features'].each_with_object([]) do |original_feature, list|
        prepared_feature = build_prepared_feature(original_feature)
        list << prepared_feature if prepared_feature.any?
      end
    end

    def build_prepared_feature(original_feature)
      values_assigned = assign_values(original_feature)

      if validate_mandatory_fields(values_assigned) &&
          validate_longitude(values_assigned) &&
          validate_latitude(values_assigned) &&
          validate_magnitude(values_assigned)
        return values_assigned
      end

      []
    end

    # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
    def assign_values(original_feature)
      place = original_feature['properties']['place']
      mag_type = original_feature['properties']['magType']
      title = original_feature['properties']['title']
      longitude = original_feature['geometry']['coordinates'][0]
      latitude = original_feature['geometry']['coordinates'][1]
      external_url = original_feature['properties']['url']
      magnitude = original_feature['properties']['mag']
      external_id = original_feature['id']
      time = original_feature['properties']['time']
      tsunami = original_feature['properties']['tsunami']

      [place, mag_type, title, longitude, latitude, external_url, magnitude, external_id, time, tsunami]
    end
    # rubocop: enable Metrics/AbcSize, Metrics/MethodLength

    def validate_mandatory_fields(values_assigned)
      true if values_assigned[0].present? && values_assigned[1].present? &&
        values_assigned[2].present? && values_assigned[5].present?
    end

    def validate_longitude(values_assigned)
      true if values_assigned[3] > -180 && values_assigned[3] < 180
    end

    def validate_latitude(values_assigned)
      true if values_assigned[4] > -90 && values_assigned[4] < 90
    end

    def validate_magnitude(values_assigned)
      true if values_assigned[6] >= -1 && values_assigned[6] <= 10
    end

    def upsert_features
      ::Feature.import(FEATURE_COLUMNS, @prepared_features,
                       on_duplicate_key_update: { conflict_target: KEYS_FOR_UPDATE, columns: UPDATE_COLUMNS },
                       validate: false, batch_size: BATCH_SIZE)
    end
  end
end
