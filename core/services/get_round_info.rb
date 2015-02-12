require 'json'
class GetRoundInfo

  def self.run
    @round = Repository.for("Round").all.first
    @round
  end

end