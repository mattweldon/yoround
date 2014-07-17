require 'sinatra'
require 'faraday'

configure do
  @round = []
end 

get '/' do
  "The Strawerry Web team Tea app, yo!"
end

get '/thirsty' do

  @round << params[:username]
  
  puts "members of the round: " round_members.join(", ")

  connection_yo.post('yo', { 
    :api_token => 'c12adfbd-6778-bada-5f73-43ac72c95007', 
    :username => round_members.sample # 
  })
  @round = []

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