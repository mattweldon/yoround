class Connection

  def self.configure(connection_klass)
    @connection_klass = connection_klass
  end

  def self.connect(options = {})
    @connection_klass.connect(options)
  end

  def self.get(url, body = {})
    @connection_klass.get(url, body)
  end

  def self.post(url, body = {})
    @connection_klass.post(url, body)
  end

end

