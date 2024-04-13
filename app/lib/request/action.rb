# frozen_string_literal: true

module Request
  class Action

    def initialize(env_name, method)
      @env_name = env_name
      @method = method
      @body = '{}'
    end

    def call
      prepare_url
      process_request
      parse_response
    end

    private

    attr_accessor :env_name
    attr_accessor :method
    attr_accessor :url
    attr_accessor :body

    def prepare_url
      @url = ENV[@env_name]
    end

    def process_request
      get if @method == :get
    end

    def parse_response
      JSON.parse(@body)
    end

    def get
      request = Typhoeus::Request.new(@url, followlocation: true)

      request.on_complete do |response|
        if response.success?
          @body = response.body
        elsif response.timed_out?
          p "got a time out"
        elsif response.code == 0
          p response.return_message
        else
          p "HTTP request failed: " + response.code.to_s
        end
      end

      request.run
    end
  end
end
