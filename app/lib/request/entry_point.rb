# frozen_string_literal: true

module Request
  class EntryPoint < BaseEntryPoint

    def initialize(env_name:, method: :get)
      @action = Action.new(env_name, method)
    end
  end
end
