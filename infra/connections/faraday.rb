module Connections
  class Faraday

    def connect(options = {})
      @connection = ::Faraday.new(:url => options.fetch(:url) { '' }) do |builder|
        builder.request  :url_encoded
        builder.response :logger
        builder.adapter  ::Faraday.default_adapter
      end
    end

    def get(url, body = {})
      @connection.get(url, body)
    end

    def post(url, body = {})
      @connection.post(url, body)
    end

  end
end