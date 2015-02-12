require 'json'
class StartRound

  def initialize(name, time)
    @name = name
    @time = time
  end

  def run
    drinker = Repository.for("Drinker").find_by_name(@name)
    round = Repository.for("Round").all.first

    # Update Round
    round.nominated_brewer = ""
    round.person_last_brewed = drinker.name
    round.time_last_made = @time
    round.current_demand.clear
    Repository.for("Round").save(round)

    # Update Drinker
    drinker.num_rounds_made = drinker.num_rounds_made + 1
    drinker.last_round_made = @time
    drinker.is_nominated = false
    Repository.for("Drinker").save(drinker)
  end

end