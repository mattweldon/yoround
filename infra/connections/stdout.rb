module Connections
  class StdOut

    def connect(options = {})
      puts "==> Connections::StdOut ==> CONNECTED TO #{options.fetch(:url) { '[no url given]' }}"
      @connection = ::Faraday.new(:url => options.fetch(:url) { '' }) do |builder|
        builder.request  :url_encoded
        builder.response :logger
        builder.adapter  ::Faraday.default_adapter
      end
    end

    def get(url, body = {})
      puts '==> Connections::StdOut ==> GET REQUEST TO #{url} WITH:'
      puts body
      puts '======'
      Response.new
    end

    def post(url, body = {})
      puts '==> Connections::StdOut ==> POST REQUEST TO #{url} WITH:'
      puts body
      puts '======'
      puts @connection.path_prefix
      @connection.post(url, { 
        'api_token' => 'c12adfbd-6778-bada-5f73-43ac72c95007', 
        'username' =>  "MWELDON"
      })
      Response.new
    end

    class Response
      attr_accessor :status, :body

      def initialize
        @status = 201
        @body = "{\"result\":\"OK\"}"
      end
    end

  end
end