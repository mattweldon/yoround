require 'faraday'

@connection = Faraday.new(:url => 'http://localhost:3004/') do |builder|
  builder.request  :url_encoded
  builder.response :logger
  builder.adapter  Faraday.default_adapter
end


while (1 == 1) do

  sleep 5
  puts "CALL /pick-brewer"
  @connection.get '/pick-brewer'

end
