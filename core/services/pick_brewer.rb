class PickBrewer

  def find
    drinkers = Repository.for('Drinker').all

    least_rounds = drinkers.min_by { |x| x.num_rounds_made }.num_rounds_made

    brewer = drinkers.each { |x| x.num_rounds_made == least_rounds}.sample

    update_brewer(brewer)
    update_round(brewer)

    brewer
  end

  def update_brewer(brewer)
    brewer.is_nominated = true
    brewer.nominated_at = Time.now
    Repository.for('Drinker').save(brewer)
  end

  def update_round(brewer)
    round = Repository.for('Round').all.first
    round.nominated_brewer = brewer.name
    round.time_nomination_made = Time.now
    Repository.for('Round').save(round)
  end

end