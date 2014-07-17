require 'sinatra'
require 'faraday'

class Tea < Sinatra::Application
  configure do
    set :round, []
    set :victim, 'no-one'
    set :round_size, 4
  end 

  get '/' do
    "The Strawerry Web Tea Round, yo!<br/><br/>The round consists of #{round_members.join(", ")}<br/><br/>It's #{settings.victim}'s turn to brew up."
  end

  get '/settings' do
    settings.round_size = params[:round_size] if params[:round_size]
    "Round size is #{settings.round_size}"
  end

  get '/thirsty' do

    settings.round << params[:username]

    puts "== MEMBERS OF THE ROUND: " + round_members.join(", ")

    if round_members.count >= settings.round_size

      victim = round_members.sample

        puts "== 4 OR MORE MEMBERS IN THE ROUND, TIME FOR #{victim} TO MAKE TEA"

        response = connection_yo.post('yo/', { 
          'api_token' => 'c12adfbd-6778-bada-5f73-43ac72c95007', 
          'username' =>  victim# 
        }) 

        puts "== YO RESPONSE: #{response.body}"

        settings.round = []
    end
  end

  private

    def round_members
      settings.round.uniq{ |x| x }
    end

    def connection_yo
      Faraday.new(:url => 'http://api.justyo.co/') do |builder|
        builder.request  :url_encoded
        builder.response :logger
        builder.adapter  Faraday.default_adapter
      end
    end
end