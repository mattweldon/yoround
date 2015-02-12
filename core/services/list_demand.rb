class ListDemand

  def run
    @round = Repository.for("Round").all.first
    @round.current_demand
  end

end