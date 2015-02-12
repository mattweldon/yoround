class Repository

  # Adds a mapping to the repository. 
  def self.configure(options = {})
    @mappings ||= {}
    @mappings.merge!(options)
  end

  # Remove all known mappings.
  def self.reset!
    @mappings = {}
  end

  # Find the defined mapping for the given entity
  def self.for(klass)
    @mappings[klass] || @mappings[klass.to_s]
  end

end