module Configuration
  class DrinkerSetup
    def self.run(env = :production)
      case env
      when :development
        Repository.for('Drinker').save(Drinker.new('OIN'))
        Repository.for('Drinker').save(Drinker.new('GLOIN'))
        Repository.for('Drinker').save(Drinker.new('ORI'))
        Repository.for('Drinker').save(Drinker.new('NORI'))
        Repository.for('Drinker').save(Drinker.new('BALIN'))
        Repository.for('Drinker').save(Drinker.new('DWALIN'))
      else
        
      end

    end
  end
end