require 'json'
class NotifyBrewer

  def initialize(name)
    @name = name
    @brewer_notified = false

    Connection.connect({:url => 'http://api.justyo.co/'})
  end

  def run
    response = Connection.post('yo/', { 
      'api_token' => ENV['YO_API_KEY'], 
      'username' =>  @name
    }) 

    if response.status == 201
      @brewer_notified = JSON.parse(response.body).fetch('result') { "" } == "OK"
    end

    yield @brewer_notified if block_given?
  end

end