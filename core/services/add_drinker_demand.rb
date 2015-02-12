require 'json'
class AddDrinkerDemand

  def initialize(name)
    @name = name
  end

  def run
    @round = Repository.for("Round").all.first
    @round.current_demand << @name
    Repository.for("Round").save(@round)
  end

end