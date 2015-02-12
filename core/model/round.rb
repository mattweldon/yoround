class Round
  
  attr_accessor :id, :time_last_made, :person_last_brewed, :nominated_brewer, 
                :time_nomination_made, :current_demand, :drinkers

  def initialize(opts = {})
    @time_last_made = Time.now
    @time_nomination_made = Time.now
    @nominated_brewer = ""
    @person_last_brewed = ""
    @current_demand = []
    @drinkers = []
  end

end