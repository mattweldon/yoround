class Settings
  
  attr_accessor :id, :high_round_demand, :long_round_gap_hours, :min_round_gap_hours

  def initialize
    @high_round_demand = 4
    @long_round_gap_hours = 1
    @min_round_gap_hours = 0.5
  end

end