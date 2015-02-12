#
# NOT YET USED.
# ---
# Need to figure out a better way of handling multiple Yo's in succession.
# The SkipRound feature should allow someone to skip their round by sending 2
# Yo's. The problem is that 1 Yo confirms the round meaning StartRound will be
# fired before the app has chance to realise SkipRound needs to run...
#
# A potential solution to this would be to have all incoming Yo's for a user
# placed in a stack which is are then picked off by an async process (CRON). The
# downside to this is that they system will always be 1 minute behind.
# 
require 'json'
class SkipRound

  def initialize(name, time)
    @name = name
    @time = time
  end

  def run
    drinker = Repository.for("Drinker").find_by_name(@name)
    round = Repository.for("Round").all.first

    # Update Round
    round.nominated_brewer = ""
    Repository.for("Round").save(round)

    # Update Drinker
    drinker.is_nominated = false
    drinker.skipped_last_nomination = true
    drinker.skipped_nomination_at @time
    Repository.for("Drinker").save(drinker)
  end

end