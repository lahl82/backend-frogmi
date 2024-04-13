# typed: strict
# frozen_string_literal: true

class BaseEntryPoint
  def call
    action.call
  end

  def self.call(*args, **kwargs)
    new(*args, **kwargs).call
  end

  private

  attr_accessor :action

end
