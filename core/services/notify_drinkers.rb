require 'json'
class NotifyDrinkers

  def initialize
    Connection.connect({:url => 'http://api.justyo.co/'})
  end

  def run
    response = Connection.post('yoall/', { 
      'api_token' => ENV['YO_NOTIFICATIONS_API_KEY']
    }) 

    if response.status == 201
      @drinkers_notified = JSON.parse(response.body).fetch('result') { "" } == "OK"
    end

    yield @drinkers_notified if block_given?
  end

end