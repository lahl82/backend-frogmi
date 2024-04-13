# frozen_string_literal: true

module Features
  class EntryPoint < BaseEntryPoint

    def initialize()
      @action = Action.new()
    end
  end
end
