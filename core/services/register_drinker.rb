require 'json'
class RegisterDrinker

  def initialize(name)
    @name = name
  end

  def run
    drinker = Repository.for('Drinker').save(Drinker.new(@name))
    round = Repository.for('Round').all.first
    round.drinkers << drinker
    Repository.for('Round').save(round)
  end

end