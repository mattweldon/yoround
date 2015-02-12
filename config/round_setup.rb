module Configuration
  class RoundSetup
    def self.run(env = :production)
      case env
      when :development
        round = Round.new
        round.drinkers << Repository.for("Drinker").all
        Repository.for('Round').save(round)
      else
        round = Round.new
        round.drinkers << Repository.for("Drinker").all
        Repository.for('Round').save(round)
      end

    end
  end
end