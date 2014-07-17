require 'sinatra'
require 'faraday'

class Tea < Sinatra::Base

  configure do
    @round = []
  end 

  get '/' do
    "The Strawerry Web team Tea app, yo!"
  end

  get '/thirsty' do

    @round << params[:username]
    
    #if round_members.length == 1
      connection_yo.post('yo', { 
        :api_token => 'c12adfbd-6778-bada-5f73-43ac72c95007', 
        :username => round_members.sample # 
      })
      @round = []
    #end

  end

  private

    def round_members
      @round.uniq{ |x| x }
    end

    def connection_yo
      Faraday.new(:url => 'http://api.justyo.co/') do |builder|
        builder.request  :url_encoded
        builder.response :logger
        builder.adapter  Faraday.default_adapter
      end
    end

end